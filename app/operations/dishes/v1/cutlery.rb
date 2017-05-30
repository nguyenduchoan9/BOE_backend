module Dishes
    module V1
        class Cutlery < Operation

            def process
                menu = []
                Category.all.each { |cate|
                    dishes = cate.dishes.all.limit(20).map{ |d| Dishes::Serializer.new(d) }
                    menu << {'category': Categories::Serializer.new(cate), 'dishes': dishes}
                }
                menu.shuffle
            end

            private


        end
    end
end
