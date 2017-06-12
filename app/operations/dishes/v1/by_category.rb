module Dishes
    module V1
        class ByCategory < Operation

            def process
                category_dish_seach_key
                # Category.all
            end

            private
            def category_params
                params[:id]
            end

            def search_key_params
                params[:search_key]
            end
            def category
                @category ||= Category.find_by(id: category_params)
            end

            def dish_by_category
                category.dishes.all.limit(120).map{ |d| Dishes::Serializer.new(d) }
            end

            def category_dish_seach_key
                category.dishes.search_cutlery(search_key_params).all.limit(120).map{ |d| Dishes::Serializer.new(d) }
            end

        end
    end
end
