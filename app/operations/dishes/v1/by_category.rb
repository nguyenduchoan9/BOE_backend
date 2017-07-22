module Dishes
    module V1
        class ByCategory < Operation

            def process
                handle_result
                # Category.all
            end

            private
            def category_params
                params[:id]
            end

            def key_search_params
                params[:search_key]
            end
            def category
                @category ||= Category.find_by(id: category_params)
            end

            def dish_by_category
                category.dishes.all.limit(120).map{ |d| Dishes::Serializer.new(d) }
            end

            def handle_result
                if is_vn_lang
                    category_dish_seach_key_vn
                else
                    category_dish_seach_key_en
                end
            end

            def category_dish_seach_key_vn
                category.dishes.search_by_dish_name(stardard_vn_key_search).all.limit(120).map{ |d| Dishes::Serializer.new(d) }
            end


            def category_dish_seach_key_en
                category.dishes.search_by_dish_name_not_mark(stardard_en_key_search).all.limit(120).map{ |d| Dishes::Serializer.new(d) }
            end

            def is_vn_lang
                detect = DetectLanguage.simple_detect(key_search_params)
                @eng_lang = false
                @vi_lang = false
                if detect != nil
                    if detect.kind_of?(Array)
                        if detect.count > 0
                            detect.each do |lang|
                                # @eng_lang = true if lang == 'en'
                                @vi_lang = true if lang == 'vi'
                            end
                        end
                    elsif detect.kind_of?(String)
                        # @eng_lang = true if detect == 'en'
                        @vi_lang = true if detect == 'vi'
                    end

                end
                return @vi_lang
                # byebug
                # if @vi_lang == true
                #     return key_search_params.mb_chars.normalize.to_s
                # end
                # key_search_params.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
            end

            def stardard_vn_key_search
                key_search_params.mb_chars.normalize.to_s
            end

            def stardard_en_key_search
                key_search_params.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
            end
        end
    end
end
