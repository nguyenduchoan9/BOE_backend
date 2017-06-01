module Dishes
    module V1
        class Drinking < Operation

            def process
                menu = []
                cate = Category.find_by(category_name: 'Drinking')
                drinking = cate.dishes.all.limit(20).map{ |d| Dishes::Serializer.new(d) }
                menu << {'category': Categories::Serializer.new(cate), 'dishes': drinking}
                menu
            end

            private


        end
    end
end
