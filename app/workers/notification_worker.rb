class NotificationWorker
    include Sidekiq::Worker
    include ApplicationHelper
    sidekiq_options :queue => :notification, :retry => false

    def perform(role, id, user_id, ver = 0)
        @role = role
        @id = id
        @user_id = user_id
        # Do something
        if Constant::WAITER == role
            body = { :table_number => table_number, :dish => dish_by_order_detail }.as_json.to_s
            # order_is_done

            send_message_to_waiter body, waiter_reg_tokens
        elsif Constant::CHEF == role
            if ver == 0
                body = { :order_id => @id, :order_detail => serial_order_detail}.as_json.to_s
                send_message_to_chef body, chef_reg_tokens, 'order'
            else
                order_detail_chef.each { |od|
                    dish_local = Dish.find(od.dish_id)
                    body = chef_dish_notify.new(dish_serializer.new(dish_local.id, dish_local.dish_name), @id).as_json.to_s
                    send_message_to_chef body, chef_reg_tokens, 'dish'
                }
            end
        elsif Constant::DINER ==role
            body = { :message => 'Your order has been rejected'}.as_json.to_s
            send_message_to_diner body, diner_reg_tokens
        end
    end

    # region WAITER
    def order_detail
        @order_detail ||= OrderDetail.find(@id)
    end

    def table_number
        # order_detail.order.table_number
        1
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
        @order ||= Order.find(@id).order_details
    end

    def serial_order_detail
        result = []
        order_detail_chef.each do |od|
            dish = Dish.find(od.dish_id)
            result << chef_result.new(dish_serializer.new(dish.id, dish.dish_name), od.quantity)
        end
        result
    end

    def chef_result
        Struct.new(:dish, :quantity)
    end

    def dish_serializer
        Struct.new(:dish_id, :dish_name)
    end

    def chef_dish_notify
        Struct.new(:dish, :order_id)
    end

    # END REGION CHEF

    # REGION DINER

    # END REGION DINER
end
