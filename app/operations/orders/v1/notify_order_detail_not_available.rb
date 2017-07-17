module Orders
    module V1
        class NotifyOrderDetailNotAvailable < Operation
            require_authen!

            def process
                notify_webapp
                {status: true}
            end

            private

            def order_details_id_params
                params[:list_order_detail_id]
                # 1_@_@_@_@_
            end

            def notify_webapp
                list_orderdetail_id = order_details_id_params.split('_')
                list_orderdetail_id.each do |order_detail_id|
                    orderdetail = OrderDetail.find order_detail_id
                    fire_base.push("rejectedOrder", {tableNumber: "#{orderdetail.order.table_number}",
                                                     status: 'new',
                                                     dishName: "#{orderdetail.dish.dish_name}",
                                                     price: "#{orderdetail.price}",
                                                     quantity: "#{orderdetail.quantity_not_serve}",
                                                     order_detail_id: "#{orderdetail.id}"})
                end
                handle_notify_to_user list_orderdetail_id
            end

            def handle_notify_to_user order_detail_ids
                next_handle_ids = []
                if order_detail_ids
                    if order_detail_ids.count > 0
                        current_user_id = nil
                        od_id_group_by_user = []
                        order_detail_ids.each do |od_id|
                            order_detail_p = OrderDetail.find od_id
                            unless current_user_id
                                current_user_id = order_detail_p.order.user.id
                                od_id_group_by_user << od_id
                            else
                                process_user_id = order_detail_p.order.user.id
                                if process_user_id == current_user_id
                                    od_id_group_by_user << od_id
                                else
                                    next_handle_ids << od_id
                                end
                            end
                        end
                        if current_user_id && od_id_group_by_user.count > 0
                            notify_to_user current_user_id, od_id_group_by_user
                        end

                        if next_handle_ids.count > 0
                            handle_notify_to_user next_handle_ids
                        end
                    end
                end
            end

            def notify_to_user user_id, order_details_ids
                NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id)
            end

            def notify_contruct
                Struct.new(:tableNumber, :status, :dishName, :price, :quantity, :order_detail_id)
            end

            def refund
                PayPal::SDK.configure(
                    :mode => "sandbox", # "sandbox" or "live"
                    :client_id => "AetzVQhJh6kV_v_GDex0IynGO_6ky0VLzvF0D3akJ7YDCVGYSrgTpIW-FAq-AdYlVW0TMJ7XdYpbCPz-",
                    :client_secret => "EP-HvkNBWll71g9q2PKfTDtWXQ0T-Nwx5_v4AXsdSeeq-Y0IChsauzdMGTriTWrD0Vi8uMclrC5shTpe",
                :ssl_options => {})
                order_detail_id = params[:order_detail_id]
                order_detail = OrderDetail.find order_detail_id
                payment_id = order_detail.order.payment_id
                payment = PayPal::SDK::REST::DataTypes::Payment.find payment_id
                json = JSON.parse payment.to_json
                @sale = PayPal::SDK::REST::DataTypes::Sale.find json["transactions"][0]["related_resources"][0]["sale"]["id"]
                total = order_detail.quantity_not_serve * order_detail.price
                @refund = @sale.refund_request({
                                                 :amount => {
                                                     :total => "1",
                                                     :currency => "USD"
                                                 }
                })
                fcm = params[:fcm]
                fire_base.delete("rejectedOrder/#{fcm}")
                redirect_to home_path
            end

            def fire_base
                @firebase ||= Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')
            end
        end
    end
end
