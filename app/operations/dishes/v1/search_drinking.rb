module Dishes
    module V1
        class SearchDrinking < Operation

            def process
                result
            end

            private
            def key_search_params
                params[:key_search]
            end

            def dish_by_key_search
                Dish.search_drinking(key_search_params)
            end

            def result
                if !key_search_params || key_search_params.length == 0
                    blank_key_search
                else
                    not_blank_key_search
                end
            end
            
            def group_dish_by_category
                dish_result = dish_by_key_search
                dish_by_cate = []
                Category.all.each { |cate|
                    dishes = []
                    dish_result.each { |dish|
                        dishes << dish if dish.category_id == cate.id
                    }
                    dish_by_cate << {'category': cate, 'dishes': dishes } if dishes && dishes.length > 0
                }
                dish_by_cate
            end

            def blank_key_search
                menu = []
                Category.all.each { |cate|
                    dishes = cate.dishes.all.limit(20).map{ |d| Dishes::Serializer.new(d) }
                    menu << {'category': Categories::Serializer.new(cate), 'dishes': dishes}
                }
                menu
            end

            def not_blank_key_search
                menu = []
                group_dish_by_category.each { |menu_item|
                    dishes = menu_item[:dishes].map{ |d| Dishes::Serializer.new(d) }
                    cate = Categories::Serializer.new(menu_item[:category])
                    menu << {'category': cate, 'dishes': dishes }
                }
                menu
            end
        end
    end
end
