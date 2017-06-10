module Dishes
    module V1
        class DisableDish < Operation

            def process
                mark_disable
                # Category.all
                { status: true }
            end

            private
            def dish_id
                params[:dish_id]
            end

            def dish
                @dish ||= Dish.find(dish_id)
            end

            def mark_disable
                dish.update!(is_available: false)
            end
        end
    end
end
