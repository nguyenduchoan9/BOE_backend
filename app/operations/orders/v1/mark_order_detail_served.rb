module Orders
    module V1
        class MarkOrderDetailServed < Operation

            def process
                do_transaction!
                # notifify each order detail to chef
                { status: true }
            end

            private
            def order_detail_id
                params[:order_detail_id]
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        mark_served
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def mark_served
                if order_detail.cooking_status == 1
                    # byebug
                    not_serve = order_detail.quantity_not_served
                    if not_serve > 0
                        # byebug
                        if not_serve == 1
                            order_detail.update(quantity_not_served: 0, cooking_status: 2)
                        else
                            order_detail.update(quantity_not_served: not_serve - 1)
                        end
                    end
                end
            end

            def order_detail
                @order_detail ||= OrderDetail.find order_detail_id
            end
        end
    end
end
