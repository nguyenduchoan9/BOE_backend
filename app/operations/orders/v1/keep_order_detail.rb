module Orders
    module V1
        class KeepOrderDetail < Operation

            def process
                mark_available
                { status: true }
            end

            private

            def od_ids
                params[:list_order_detail_id]
            end

            def mark_available
                begin
                    ActiveRecord::Base.transaction do
                        od_ids.split('_').uniq.each do |id|
                            od = OrderDetail.find id
                            od.update(cooking_status: 0)
                        end
                    end

                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end
        end
    end
end
