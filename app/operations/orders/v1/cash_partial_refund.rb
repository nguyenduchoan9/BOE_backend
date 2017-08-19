module Orders
    module V1
        class CashPartialRefund < Operation
            require_authen!

            def process
                notify_webapp
                {status: true}
            end

            private

            def order_params
                params[:orderId]
                # 1_@_@_@_@_
            end

            def dish_list_params
                params[:dishId]
            end

            def order
                @order ||= Order.find order_params
            end

            def check_dish_cart_avilable
                reject_dish = []
                order.order_details.each do |od|
                    reject_dish << od.id unless is_dish_available od.dish_id
                    od.cooking_status = 0
                    od.save
                end
                reject_dish
            end

            def notify_webapp
                list_orderdetail_id = check_dish_cart_avilable
                # handle_notify_to_user list_orderdetail_id
                # byebug
                handle_refund list_orderdetail_id
                NotificationWorker.perform_async(Constant::CHEF, order.id, user.id, 1, 0)
            end

            def handle_refund ids
                # order detail ids
                i = 0
                ids.each do |id|
                    order_detail = OrderDetail.find id
                    order_detail.cooking_status = 3
                    order_detail.save
                    if order_detail.order.payment_method == 0
                        HardWorker.perform_async([id], Constant::PAYPAL_METHOD)
                    else
                        refund_via_balance id
                    end
                end
            end

            def refund_via_balance(order_detail_id)
                # byebug
                order_detail = OrderDetail.find order_detail_id
                total = order_detail.price * order_detail.quantity_not_serve
                order_detail.order.user.balance += total
                order_detail.order.user.save!
                order_detail.cooking_status = 4
                order_detail.save!
                allowance = Allowance.new
                allowance.order_id = order_detail.order.id
                allowance.total = total
                allowance.save!
                order_detail.order.total -= total
                order_detail.order.save!
                user_id = order_detail.order.user_id
                notify_to_user user_id, order_detail_id.to_i, total
            end

            def notify_to_user user_id, order_details_ids, total_refund
                NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 2, total_refund)
            end

            def update_total order_details_ids
                minus_total = 0
                order_details_ids.each do |od_id|
                    od = OrderDetail.find od_id
                    minus_total += (od.quantity_not_serve * od.price)
                end
                # byebug
                begin
                    ActiveRecord::Base.transaction do
                        order = OrderDetail.find(@id.first).order
                        order.update(total: order.total - minus_total)
                    end
                rescue StandardError => error
                    puts "Error - list_dish_notify"
                end
            end

            # def notify_to_user user_id, order_details_ids
            #     NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 0, 0)
            # end

            def notify_contruct
                Struct.new(:tableNumber, :status, :dishName, :price, :quantity, :order_detail_id)
            end
        end
    end
end
