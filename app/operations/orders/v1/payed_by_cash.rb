module Orders
    module V1
        class PayedByCash < Operation
            # require_authen!

            def process
                do_transaction!
                s = check_dish_cart_avilable
                if s.size == 0
                    NotificationWorker.perform_async(Constant::CHEF, order.id, user.id, 1, 0)
                else
                    # byebug
                    NotificationWorker.perform_async(Constant::DINER, s, order.user_id, 3, 0)
                end
                # result.new(order.id, list_dish_reject)
                {status: true}
            end

            private

            def order_params
                params[:orderId]
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        order.update!(cooking_status: 0)
                        # check material
                    end

                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def user_id_diner od_id
                OrderDetail.find(od_id).order.user_id
            end

            def cart_object
                Struct.new(:dish, :quantity)
            end

            def order
                @order ||= Order.find order_params
            end

            def check_dish_cart_avilable
                reject_dish = []
                order.order_details.each do |od|
                    reject_dish << od.id unless is_dish_available od.dish_id
                end
                reject_dish
            end

            def list_dish_reject
                rs = []
                check_dish_cart_avilable.each do |ids|
                    rs << Dishes::Serializer.new(Dish.find(ids))
                end
                rs
            end

            def result
                Struct.new(:order_id, :dish)
            end
        end
    end
end
# -1: dish is cancel
# 0 : dish is cooking
#  1: dish is finish cooking
