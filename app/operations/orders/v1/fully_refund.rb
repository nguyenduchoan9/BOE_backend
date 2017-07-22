module Orders
    module V1
        class FullyRefund < Operation
            require_authen!

            def process
                do_transaction!
                {status: true}
            end

            private

            def order_id_params
                params[:orderId]
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        change_order_detail_cancel
                        change_order_cancel
                    end

                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def order
                @order ||= Order.find(order_id_params)
            end

            def change_order_detail_cancel
                order.order_details.each do |od|
                    od.update!(cooking_status: -1)
                end
            end

            def change_order_cancel
                order.update!(cooking_status: -1, total: 0)
            end
        end
    end
end
# -1: dish is cancel
# 0 : dish is cooking
#  1: dish is serving
# 2: done
# 3: refunding
# 4: refunded
