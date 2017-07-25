class PayPalController < ApplicationController

  def notify_webapp
    firebase = Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')
    list_orderdetail_id = params[:list_orderdetail_id].split('_')
    list_orderdetail_id.each do |order_detail_id|
      orderdetail = OrderDetail.find order_detail_id
      firebase.push("rejectedOrder", {tableNumber: "#{orderdetail.order.table_number}", status: 'new', dishName: "#{orderdetail.dish.dish_name}", price: "#{orderdetail.price}", quantity: "#{orderdetail.quantity_not_serve}", order_detail_id: "#{orderdetail.id}"})
    end
    render nothing: true
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
    json = JSON.parse HTTParty.get("http://apilayer.net/api/live?access_key=088bcad87c3fd862b4793c2f535089ba").to_json
    rate = json["quotes"]["USDVND"].to_f
    usdTotal = (total.to_f / rate).round(2)
    @refund = @sale.refund_request({
                                       :amount => {
                                           :total => "#{usdTotal}",
                                           :currency => "USD"
                                       }
                                   })

    # firebase = Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')
    # fcm = params[:fcm]
    # firebase.delete("rejectedOrder/#{fcm}")

    order_detail.cooking_status = 4
    order_detail.order.total -= total
    order_detail.order.save!
    order_detail.save!
    # puts order_detail.created_at.strftime('%d/%m/%Y')
    redirect_to home_path(term: order_detail.created_at.strftime('%d/%m/%Y'))
  end
end
