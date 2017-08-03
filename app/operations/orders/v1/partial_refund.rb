module Orders
    module V1
        class PartialRefund < Operation
            require_authen!

            def process
                do_transaction!
                NotificationWorker.perform_async(Constant::CHEF, order.id, user.id, 1)
                {status: true}
            end

            private

            def order_id_params
                params[:orderId]
            end

            def minus_money_params
                params[:total]
            end

            def dish_id_params
                params[:dishes]
            end

            def order
                @order ||= Order.find(order_id_params)
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        change_order_detail_cancel
                        update_order_total
                        od_not_available = check_and_get_not_available_od
                        if od_not_available && od_not_available.count > 0
                            byebug
                            notify_to_user user.id, od_not_available
                        end
                    end

                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def change_order_detail_cancel
                order.order_details.each do |od|
                    if dish_list_id.include? od.dish_id.to_s
                        od.update!(cooking_status: -1)
                    end
                end
            end

            def update_order_total
                total = order.total
                minus_total = total - minus_money_params.to_d
                order.update!(total: minus_total)
            end

            def dish_list_id
                @dish_list_id ||= dish_id_params.split('_')
            end

            def check_and_get_not_available_od
                rs = []
                byebug
                order.order_details.where('cooking_status = 0').each do |od|
                    unless is_dish_available od.dish.id
                        rs << od.id
                        od.update(cooking_status: 3)
                    end
                end
                byebug
                rs
            end

            def notify_to_user user_id, order_details_ids
                NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 0, 0)
            end
        end
    end
end
# -1: dish is cancel
# 0 : dish is cooking
#  1: dish is finish cooking
