class NotificationWorker
    include Sidekiq::Worker
    include ApplicationHelper
    sidekiq_options :queue => :notification, :retry => false

    def perform(role, id, user_id, ver = 0, total_refund)
        @role = role
        @id = id
        @user_id = user_id
        # Do something
        if Constant::WAITER == role
            body = { :table_number => table_number, :dish => dish_by_order_detail, :order_detail_id => order_detail.id }.as_json.to_s
            # order_is_done

            if order_detail.cooking_status == 1 || order_detail.cooking_status == 0
                send_message_to_waiter body, waiter_reg_tokens
            end
        elsif Constant::CHEF == role
            if ver == 0
                body = { :order_id => @id, :order_detail => serial_order_detail}.as_json.to_s
                # byebug
                send_message_to_chef body, chef_reg_tokens, 'order'
            elsif ver == 1
                # notify dish in orderDetail to Chef
                # Maybe include dish is not available because transfer to GCM
                order_detail_chef.each { |od|
                    dish_local = Dish.find(od.dish_id)
                    des_arr = od.description.split(Constant::SEPARATE_CHARATER_DES)
                    od.quantity.times do |index|
                        des_item = des_arr[index] == Constant::BLANK_CHARATER ? "" : des_arr[index]
                        if dish_local.is_available
                            body = chef_dish_notify.new(dish_serializer.new(dish_local.id, dish_local.dish_name, od.id), @id, des_item).as_json.to_s
                            send_message_to_chef body, chef_reg_tokens, 'dish'
                        end
                    end
                }
            elsif ver == 2
                # role, id, user_id, ver = 0, total_refund
                body = {:ids => id}.as_json.to_s

                send_message_to_chef body, chef_reg_tokens, 'canceldish'
            end
        elsif Constant::DINER ==role
            # byebug
            if ver == 0
                # byebug
                body = list_dish_notify
                send_message_to_diner body, diner_reg_tokens, "notification"
            elsif ver == 1
                # byebug
                # list order_detail
                # od_id_list = id.split('-')
                od = OrderDetail.find id.first
                items = list_item_after_refund id
                # byebug
                body = after_refund_struct.new(total_refund, items, od.order.id, od.order.table_number, DateUtils.format_date(od.created_at))
                # byebug
                send_message_to_diner body, diner_reg_tokens, "cashPending"
            elsif ver == 2
                od = OrderDetail.find id
                items = list_item_after_refund [id]
                # byebug
                body = after_refund_struct.new(total_refund, items, od.order.id, od.order.table_number, DateUtils.format_date(od.created_at))
                # byebug
                send_message_to_diner body, diner_reg_tokens, "afterRefund"
            elsif ver == 3
                # byebug
                order_id = OrderDetail.find(id.first).order_id
                

                body = notify_after_payed_by_cash.new(order_id, convert_od_id_to_dish_list(id))
                send_message_to_diner body, diner_reg_tokens, "cashPending"
            end
        elsif Constant::CASHIER == role
            order_body = Order.find id
            body = format_notify_cashier.new(order_body.total, id, order_body.table_number)
            send_message_to_cashier body, cashier_reg_tokens, "notification"
        end
    end

    # region WAITER
    def order_detail
        @order_detail ||= OrderDetail.find(@id)
    end

    def table_number
        order_detail.order.table_number
        # 1
    end

    def order_is_done
        is_done = true;
        order_detail.order.order_details.each{ |od|
            is_done = false if od.cooking_status != 1
        }
        order_detail.order.update!(cooking_status: 1) if is_done
    end

    def dish_by_order_detail
        dish_detail = Dish.find(order_detail.dish_id)
        waiter_notify.new(dish_detail.id, dish_detail.dish_name)
    end

    def waiter_notify
        Struct.new(:dish_id, :dish_name)
    end

    def list_item_after_refund order_detail_id_list
        rs = []
        if order_detail_id_list
            if order_detail_id_list.count > 0
                order_detail_id_list.each do |id|
                    od = OrderDetail.find id
                    quantity = od.quantity_not_serve
                    item = after_refund_item_refund.new(od.dish.dish_name, od.price, quantity)
                    rs << item
                end
            end
        end
        rs
    end

    def after_refund_struct
        Struct.new(:total, :dishes, :order_id, :table_number, :date)
    end

    def after_refund_item_refund
        Struct.new(:dish_name, :price, :quantity)
    end
    # END REGION WAITER

    def waiter_reg_tokens
        User.find_by(:username => 'masterwaiter').reg_token
    end

    def chef_reg_tokens
        User.find_by(:username => 'masterchef').reg_token
    end

    def diner_reg_tokens
        User.find(@user_id).reg_token
    end

    # REGION CHEF
    def order_detail_chef
        @order ||= Order.find(@id).order_details.order(created_at: :asc).where(cooking_status: 0)
    end

    def serial_order_detail
        result = []
        order_detail_chef.each do |od|
            dish = Dish.find(od.dish_id)
            result << chef_result.new(dish_serializer.new(dish.id, dish.dish_name, od.id), od.quantity)
        end
        result
    end

    def chef_result
        Struct.new(:dish, :quantity)
    end

    def dish_serializer
        Struct.new(:dish_id, :dish_name, :order_detail_id)
    end

    def chef_dish_notify
        Struct.new(:dish, :order_id, :description)
    end

    def chef_cancel_dish
        Struct.new(:order_detail_id)
    end

    # END REGION CHEF

    # REGION DINER
    def list_dish_notify
        rs = []
        dish_list = []
        dish_list_id = []
        minus_total = 0
        # byebug
        @id.each do |od_id|
            od = OrderDetail.find od_id
            minus_total += (od.quantity_not_serve * od.price)
            dish = Dish.find od.dish.id
            unless dish_list_id.index dish.id
                dish_list_id << dish.id
                rs << Dishes::Serializer.new(dish)
            end
            # byebug
        end
        # begin
        #     ActiveRecord::Base.transaction do
        #         order = OrderDetail.find(@id.first).order
        #         order.update(total: order.total - minus_total)
        #     end
        # rescue StandardError => error
        #     puts "Error - list_dish_notify"
        # end
        # byebug
        rs
    end

    def format_notify_user
        Struct.new(:dish, :quantity)
    end
    # END REGION DINER


    # START REGION CASHIER
    def format_notify_cashier
        Struct.new(:total, :order_id, :table_number)
    end

    def cashier_reg_tokens
        User.find_by(:username => 'mastercashier').reg_token
    end

    def convert_od_id_to_dish_list od_id
        rs = []
        od_id.each do |id|
            od = OrderDetail.find id
            rs << Dishes::Serializer.new(Dish.find(od.dish))
        end
        rs
    end

    def notify_after_payed_by_cash
        Struct.new(:order_id, :dish)
    end
    # END REGION CASHIER
end
