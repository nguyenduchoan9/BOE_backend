module Orders
    module V1
        class DishDone < Operation

            require_authen!

            def process
                do_transaction!
                # HardWorker.perform_async(:level => "easy")
                NotificationWorker.perform_async(Constant::WAITER, order_detail_id, user.id)
                {}
            end

            private

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        mark_done
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def order_detail_id
                params[:order_detail_id]
            end

            def order_detail
                @order_detail ||= OrderDetail.find(order_detail_id)
            end

            def mark_done
                order_detail.update!(cooking_status: 1)
            end

            def order_id
                order_detail.order.id
            end

        end
    end
end
