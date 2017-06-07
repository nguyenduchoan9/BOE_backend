module Orders
    module V1
        class Create < Operation
            require_authen!

            def process
                do_transaction!
                NotificationWorker.perform_async(Constant::CHEF, order.id, user.id)
                {status: true}
            end

            private

            def order_params
                params[:order]
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        OrderDetail.import(build_order_details)
                        order.update!(total: total)
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def list_cart_object
                cart_list = []
                dish = ''
                order_params.split('_').each_with_index do |item, index|
                    if index.even?
                        dish = Dish.find(item)
                    elsif index.odd?
                        cart_item = cart_object.new(dish, item)
                        cart_list << cart_item
                    end
                end
                cart_list
            end

            def build_order_details
                list_cart_object.map do |cart|
                    order.order_details.new(
                        price: cart[:dish].price_change_histories.order(from_date: :asc).last.try(:price),
                        discount_rate_by_day: 0,
                        quantity: cart[:quantity],
                        dish_id: cart[:dish].id
                    )
                end
            end

            def cart_object
                Struct.new(:dish, :quantity)
            end

            def total
                order.order_details.reduce(0) do |result, order_details|
                    result + (order_details.price * order_details.quantity)
                end
            end

            def order
                @order ||= user.orders.create!
            end
        end
    end
end
