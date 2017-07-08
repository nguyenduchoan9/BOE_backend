module Materials
    module V1
        class MarkNotAvailable < Operation

            def process
                mark_not_available
                @rs
            end

            private
            def material_id_params
                params[:ids]
            end

            def split_id
                material_id_params.split('')
            end

            def get_recent_order
                @order ||= Order.where('created_at < ? AND created_at > ?',Time.now, Time.now - 1.day).order(created_at: :desc)
            end

            def mark_not_available
                begin
                    ActiveRecord::Base.transaction do
                        split_id.each do |id|
                            Material.find(id).update!(available: false)
                        end
                        update_order_detail
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def update_order_detail
                @rs = []
                get_recent_order.order_details do |od|
                    if is_have_material material_id_params, od.dish_id
                        od.update!(cooking_status: -1)
                        @rs << od.id
                    end
                end
                @rs
            end

            def is_have_material material_id, dish_id
                dish = Dish.find(dish_id)
                dish.material_id == material_id
            end

        end
    end
end
