module Orders
    module V1
        class MarkListOrderDetailServed < Operation

            def process
                do_transaction!
                # notifify each order detail to chef
                { status: true }
            end

            private
            def list_order_detail_id
                params[:list_order_detail_id]
            end

            def get_list_id
                @list_id ||= list_order_detail_id.split('_')
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
                if get_list_id.count > 0
                    # byebug
                    get_list_id.each do |id|
                        order_detail = find_order_detail id
                        if order_detail.cooking_status == 1 || order_detail.cooking_status == 0
                            quantity_minus = order_detail.quantity_not_served - order_detail.quantity_not_serve
                            if order_detail.quantity > order_detail.quantity_not_serve && quantity_minus > 0
                                not_serve = order_detail.quantity_not_served
                                if order_detail.quantity_not_serve == 0
                                    order_detail.update(quantity_not_served: 0, cooking_status: 2)
                                elsif not_serve > 0
                                    order_detail.update(quantity_not_served: order_detail.quantity_not_serve)
                                end
                            end
                        elsif order_detail.cooking_status == 3 || order_detail.cooking_status == 4
                            quantity_minus = order_detail.quantity_not_served - order_detail.quantity_not_serve
                            if order_detail.quantity > order_detail.quantity_not_serve && quantity_minus > 0
                                order_detail.update(quantity_not_served: order_detail.quantity_not_serve)
                            end
                        end
                    end
                end

            end

            def find_order_detail id_params
                OrderDetail.find id_params
            end
        end
    end
end
