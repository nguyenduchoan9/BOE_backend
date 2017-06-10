module Orders
    module V1
        class MarkOrderReject < Operation
            require_authen!

            def process
                do_transaction!
                { status: true}
            end

            private
            def order_id
                params[:order_id]
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        mark_reject
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def mark_reject
                order.order_details.each{ |o|
                    o.update!(cooking_status: -2)
                }
                order.update!(cooking_status: -2)
            end

            def order
                @order ||=Order.find(order_id)
            end
        end
    end
end
