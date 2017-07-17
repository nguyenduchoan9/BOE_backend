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

            def format_params_utf
                detect = DetectLanguage.simple_detect(key_search_params)
                @eng_lang = false
                @vi_lang = false
                if detect != nil
                    if detect.kind_of?(Array)
                        if detect.count > 0
                            detect.each do |lang|
                                @eng_lang = true if lang == 'en'
                                @vi_lang = true if lang == 'vi'
                            end
                        end
                    elsif detect.kind_of?(String)
                        @eng_lang = true if detect == 'en'
                        @vi_lang = true if detect == 'vi'
                    end

                end
                # byebug
                if @vi_lang == true
                    return key_search_params.mb_chars.normalize.to_s
                end
                key_search_params.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
            end

            def dish_by_key_search
                if @vi_lang == true
                    return Dish.search_by_dish_name(format_params_utf)
                end
                Dish.search_by_dish_name_not_mark(format_params_utf)
            end

            def result
                if !format_params_utf || format_params_utf.length == 0
                    blank_key_search
                else
                    not_blank_key_search
                end
            end

            def group_dish_by_category
                dish_result = dish_by_key_search
                dish_by_cate = []
                if dish_result.count > 0
                    Category.all.each { |cate|
                        dishes = []
                        dish_result.each { |dish|
                            dishes << dish if dish.category_id == cate.id
                        }
                        dish_by_cate << {'category': cate, 'dishes': dishes } if dishes && dishes.length > 0
                    }
                end
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
