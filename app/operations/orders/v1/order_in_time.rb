module Orders
    module V1
        class OrderInTime < Operation
            require_authen!

            def process
                result
            end

            private
            def list_order_params
                params["list_order"]
            end

            def get_order_list_id
                list_order_params.split('_')
            end

            def get_order
                orders = []
                get_order_list_id.each do |i|
                    orders << Order.find(i)
                end
                orders
            end

            def result
                rs = []
                total = 0
                get_order.each do |order|
                    total += order.total
                    order.order_details.each do |od|
                        dish = Dish.find(od.dish_id)
                        rs << order_detail_construct.new(dish.dish_name, od.quantity, od.price, DateUtils.format_date(od.create_at))
                    end
                end
                result_construct(total, rs)
            end

            def result_construct
                Construct.new(:total, :list_order_detail)
            end

            def order_detail_construct
                Construct.new(:dish_name, :quantity, :price, :create_at)
            end
        end
    end
end
