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
        :client_id => "AVgD-aYUhsUuxtwUhIS0Ry3bS_rqFJkc4XLdV3CExGsmyMNJ1yYzYqGyCtmfa8FN_LTTcH04jzFVjcie",
        :client_secret => "EGO-YRcOXWEQaGSpt09KjpPNA-itKeF1v1v7bpuqP5Pjh_8MdArOxy7fdDjqI6DSe38Oj2iDjVuxHJaj",
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
    firebase = Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')
    fcm = params[:fcm]
    firebase.delete("rejectedOrder/#{fcm}")
    order_detail.cooking_status = 3
    redirect_to home_path
  end
end