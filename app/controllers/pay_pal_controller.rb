class PayPalController < ApplicationController

  # @payout = PayPal::SDK::REST::DataTypes::Payout.new(
  #     {
  #         :sender_batch_header => {
  #             :sender_batch_id => SecureRandom.hex(8),
  #             :email_subject => 'You have a Payout!',
  #         },
  #         :items => [
  #             {
  #                 :recipient_type => 'EMAIL',
  #                 :amount => {
  #                     :value => '100',
  #                     :currency => 'USD'
  #                 },
  #                 :note => 'Thanks for your patronage!',
  #                 :receiver => 'nguyendhoan9-buyer@gmail.com',
  #                 :sender_item_id => "2014031400023",
  #             }
  #         ]
  #     }
  # )
  #
  # payout_batch = @payout.create

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
    order_id = params[:order_id]
    order = Order.find order_id
    total = 0
    order.order_details.where(cooking_status: 3).each do |order_detail|
      total += (order_detail.price * order_detail.quantity_not_serve)
    end
    payment_id = order.payment_id
    payment = PayPal::SDK::REST::DataTypes::Payment.find payment_id
    json = JSON.parse payment.to_json
    @sale = PayPal::SDK::REST::DataTypes::Sale.find json["transactions"][0]["related_resources"][0]["sale"]["id"]
    json = JSON.parse HTTParty.get("http://apilayer.net/api/live?access_key=088bcad87c3fd862b4793c2f535089ba").to_json
    rate = json["quotes"]["USDVND"].to_f
    usdTotal = (total.to_f / rate).round(2)
    @refund = @sale.refund_request({
                                       :amount => {
                                           :total => "#{'%.02f' % usdTotal}",
                                           :currency => "USD"
                                       }
                                   })
    order.order_details.where(cooking_status: 3).each do |order_detail|
      order_detail.cooking_status = 4
      order_detail.save!
    end
    order.total -= total
    order.save!
    redirect_to home_path(term: order.created_at.strftime('%d/%m/%Y'))
  end
end
