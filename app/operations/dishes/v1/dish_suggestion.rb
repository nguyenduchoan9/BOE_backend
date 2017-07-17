module Dishes
    module V1
        class DishSuggestion < Operation

            def process
                get_id_and_name_dish
            end

            private
            def get_id_and_name_dish
                cutlery = []
                Dish.all.where('category_id != 5').each do |dish|
                    cutlery << result_format.new(dish.id, dish.dish_name)
                end
                drinking = []
                Dish.all.where('category_id = 5').each do |dish|
                    drinking << result_format.new(dish.id, dish.dish_name)
                end
                categorize_result.new(cutlery, drinking)
            end

            def result_format
                Struct.new(:id, :dish_name)
            end

            def categorize_result
                Struct.new(:cutlery, :drinking)
            end
        end
    end
end
