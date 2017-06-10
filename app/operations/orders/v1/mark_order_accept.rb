module Orders
    module V1
        class MarkOrderAccept < Operation
            require_authen!

            def process
                do_transaction!
                # notifify each order detail to chef
                NotificationWorker.perform_async(Constant::CHEF, order.id, user.id, 1)
                { status: true }
            end

            private
            def order_id
                params[:order_id]
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        mark_accept
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def mark_accept
                order.order_details.each{ |o|
                    o.update!(cooking_status: 0)
                }
                order.update!(cooking_status: 0)
            end

            def order
                @order ||=Order.find(order_id)
            end
        end
    end
end
