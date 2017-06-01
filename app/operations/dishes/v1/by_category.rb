module Dishes
    module V1
        class ByCategory < Operation

            def process
                dish_by_category
                # Category.all
            end

            private
            def category_params
                params[:id]
            end

            def category
                Category.find_by(id: category_params)
            end

            def dish_by_category
                category.dishes.all.limit(120).map{ |d| Dishes::Serializer.new(d) }
            end

        end
    end
end
