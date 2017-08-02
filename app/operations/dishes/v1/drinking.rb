module Dishes
    module V1
        class Drinking < Operation

            def process
                menu = []
                cate = Category.find_by(category_name: 'Nước')
                drinking = cate.dishes.all.limit(20).map{ |d| Dishes::Serializer.new(d) if is_dish_available d.id}
                menu << {'category': Categories::Serializer.new(cate), 'dishes': drinking}
                menu
            end

            private


        end
    end
end
