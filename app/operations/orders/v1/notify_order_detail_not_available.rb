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
# -1: dish is cancel
# 0 : dish is cooking
#  1: dish is finish cooking
