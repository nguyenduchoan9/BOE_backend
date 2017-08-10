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

            def get_recent_order
                @order ||= Order.where('created_at < ? AND created_at > ? AND cooking_status = 0',Time.now, Time.now - 1.day).order(created_at: :asc)
            end

            def mark_not_available
                begin
                    ActiveRecord::Base.transaction do
                        Material.find(material_id_params).update!(available: false)
                        update_order_detail
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def update_order_detail
                @rs = []
                if get_recent_order
                    # byebug
                    get_recent_order.each do |oder_m|
                        # byebug
                        total_minus = 0
                        oder_m.order_details.each do |od|
                            # byebug
                            if od.cooking_status == 0
                                if is_have_material material_id_params.to_i, od.dish_id
                                    od.update!(cooking_status: 3)
                                    total_minus += od.quantity_not_serve * od.price
                                    @rs << od.id
                                end
                            end
                        end
                        # byebug
                        # if total_minus > 0
                        #     oder_m.update(total: oder_m.total - total_minus)
                        # end
                    end
                end
                # byebug
                @rs
            end

            def is_have_material material_id, dish_id
                dish = Dish.find(dish_id)
                dish.material_id == material_id
            end

        end
    end
end
