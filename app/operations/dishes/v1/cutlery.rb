module Dishes
    module V1
        class Cutlery < Operation

            def process
                menu = []
                Category.all.where.not(id: 5).all.each { |cate|
                    dishes = cate.dishes.all.limit(20).map{ |d| Dishes::Serializer.new(d) if is_dish_available d.id }
                    menu << {'category': Categories::Serializer.new(cate), 'dishes': dishes.compact} 
                }
                menu
            end

            private


        end
    end
end
