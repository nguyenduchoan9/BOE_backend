module Dishes
    module V1
        class AsCart < Operation

            def process
                list_cart_object
            end

            private
            def cart_params
                params[:cart]
            end

            def list_cart_object
                cart_list = []
                dish = ''
                cart_params.split('_').each_with_index do |item, index|
                    if index.even?
                        dish = Dishes::Serializer.new(dish_by_id(item.to_i))
                    elsif index.odd?
                        cart_item = cart_object.new(dish, item)
                        cart_list << cart_item
                    end
                end
                cart_list
            end

            def dish_by_id(id)
                Dish.find(id)
            end

            def cart_object
                Struct.new(:dish, :quantity)
            end
        end
    end
end
