class HardWorker
    include Sidekiq::Worker
    include ApplicationHelper
    sidekiq_options :queue => :default, :retry => false

    def perform(order_detail_id, payment_method)
        if payment_method == Constant::PAYPAL_METHOD
            refund_via_paypal order_detail_id.first
        else
            refund_via_balance order_detail_id.first
        end

    end

    def refund_via_paypal(order_detail_id)
        PayPal::SDK.configure(
            :mode => "sandbox", # "sandbox" or "live"
            :client_id => "AetzVQhJh6kV_v_GDex0IynGO_6ky0VLzvF0D3akJ7YDCVGYSrgTpIW-FAq-AdYlVW0TMJ7XdYpbCPz-",
            :client_secret => "EP-HvkNBWll71g9q2PKfTDtWXQ0T-Nwx5_v4AXsdSeeq-Y0IChsauzdMGTriTWrD0Vi8uMclrC5shTpe",
        :ssl_options => {})
        order_detail = OrderDetail.find order_detail_id
        total = (order_detail.price.to_f * order_detail.quantity_not_serve.to_f)
        payment_id = order_detail.order.payment_id
        payment = PayPal::SDK::REST::DataTypes::Payment.find payment_id
        json = JSON.parse payment.to_json
        sale = PayPal::SDK::REST::DataTypes::Sale.find json["transactions"][0]["related_resources"][0]["sale"]["id"]
        json = JSON.parse HTTParty.get("http://apilayer.net/api/live?access_key=088bcad87c3fd862b4793c2f535089ba").to_json
        rate = json["quotes"]["USDVND"].to_f
        usdTotal = (total.to_f / rate).round(2)
        refund = sale.refund_request({
                                         :amount => {
                                             :total => "#{'%.02f' % usdTotal}",
                                             :currency => "USD"
                                         }
        })
        order_detail.cooking_status = 4
        order_detail.save!
        allowance = Allowance.new
        allowance.order_id = order_detail.order.id
        allowance.total = total
        allowance.save!
        user_id = order_detail.order.user_id
        notify_to_user user_id, order_detail_id.to_i, total
    end

    def refund_via_balance(order_detail_id)
        order_detail = OrderDetail.find order_detail_id
        total = order_detail.price * order_detail.quantity_not_serve
        order_detail.order.user.balance += total
        order_detail.order.user.save!
        order_detail.cooking_status = 4
        order_detail.save!
        allowance = Allowance.new
        allowance.order_id = order_detail.order.id
        allowance.total = total
        allowance.save!
        user_id = order_detail.order.user_id
        notify_to_user user_id, order_detail_id.to_i, total
    end

    def notify_to_user user_id, order_details_ids, total_refund
        NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 2, total_refund)
    end
end
