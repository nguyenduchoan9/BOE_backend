module Orders
    module V1
        class DishDone < Operation

            require_authen!

            def process
                # do_transaction!
                # HardWorker.perform_async(:level => "easy")
                NotificationWorker.perform_async(Constant::WAITER, order_detail_id, user.id)
                { status: true }
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

            def order_id
                params[:order_id]
            end

            def dish_id
                params[:dish_id]
            end

            def order_detail
                @order_detail ||= Order.find(order_id).order_details.find_by(:dish_id => dish_id)
            end

            def order_detail_id
                order_detail.id
            end
            receive
            # order_id
            # dish_id

        end
    end
end
