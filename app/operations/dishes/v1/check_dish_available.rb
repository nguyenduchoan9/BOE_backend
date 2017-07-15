module Dishes
    module V1
        class CheckDishAvailable < Operation

            def process
                list_dish_not_available
            end

            private
            def dishes_params
                params[:ids]
            end

            def list_id
                dishes_params.split('_')
            end

            def list_dish_not_available
                rs = []
                if list_id.count > 0
                    list_id.each do |id|
                        dish = Dish.find(id)
                        rs << not_available_res.new(id, dish.dish_name) unless is_dish_available id
                    end
                end
                rs.compact
            end

            def not_available_res
                Struct.new(:id, :name)
            end

        end
    end
end
