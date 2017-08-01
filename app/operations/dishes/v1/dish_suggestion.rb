module Dishes
    module V1
        class DishSuggestion < Operation

            def process
                get_id_and_name_dish
            end

            private
            def get_id_and_name_dish
                dish_result = []
                Dish.all.each do |dish|
                    if is_dish_available dish.id
                        dish_result << result_format.new(dish.id, dish.dish_name)
                    end
                end
                
                categorize_result.new(dish_result)
            end

            def result_format
                Struct.new(:id, :dish_name)
            end

            def categorize_result
                Struct.new(:dish)
            end
        end
    end
end
