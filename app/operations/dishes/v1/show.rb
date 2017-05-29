module Dishes
    module V1
        class Show < Operation

            def process
                Dishes::Serializer.new(dish)
            end

            private
            def dish_params
                params[:id]
            end

            def dish
                Dish.find_by(id: dish_params)
            end

            def result
                Struct.new(:body)
            end
        end
    end
end
