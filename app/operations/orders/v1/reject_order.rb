module Orders
    module V1
        class RejectOrder < Operation

            def process
                do_transaction
                # notifi to diner
                {}
            end

            private
            def do_transaction
            	begin
                    ActiveRecord::Base.transaction do
                   		mark_reject
                   		order.update!(:cooking_status => -2)
                    end
                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def order_id
            	params[:order_id]
            end

            def order
            	@order ||= Order.find(order_id)
            end

            def order_details
            	@order_details ||= order.order_details
            end

            def mark_reject
            	order_details.each do |i|
            		i.update!(cooking_status: -2)
            	end 
            end
        end
    end
end
