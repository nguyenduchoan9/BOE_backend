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
                        quantity_served = od.quantity - od.quantity_not_serve
                        unless od.cooking_status == -1
                            if od.cooking_status == 3 || od.cooking_status == 4
                                unless quantity_served == 0
                                    dish = Dish.find(od.dish_id)
                                    rs << order_detail_construct.new(dish.id, dish.dish_name, quantity_served, od.price, DateUtils.format_date(od.created_at))
                                end
                            else
                                unless od.quantity == 0
                                    dish = Dish.find(od.dish_id)
                                    rs << order_detail_construct.new(dish.id, dish.dish_name, od.quantity, od.price, DateUtils.format_date(od.created_at))
                                end
                            end
                        end
                    end
                end
                result_construct.new(total, rs)
            end

            def result_construct
                Struct.new(:total, :list_order_detail)
            end

            def order_detail_construct
                Struct.new(:id, :dish_name, :quantity, :price, :create_at)
            end
        end
    end
end
