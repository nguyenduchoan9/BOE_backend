class PayPalController < ApplicationController
  # PayPal::SDK.configure(
  #     :mode => "sandbox", # "sandbox" or "live"
  #     :client_id => "Aa-zOjgWjSCBw9UWHHvxRihf2S2yvBpEjKiGWCu7dFUsa0Lsmd5J9jMpL0OxZOaJziPPh_mAIUzVzSBc",
  #     :client_secret => "EMxsOJ9oG-d2RJR4vGfFAP5SOwyZChfviEZMFUGzqjZGVVVweS3tZf-ufMea5avVCl5PQe0ZiwqTrz__",
  #     :ssl_options => {})
  # @payment = PayPal::SDK::REST::Payment.new({
  #                                               :intent => "sale",
  #                                               :payer => {
  #                                                   :payment_method => "credit_card",
  #                                                   :funding_instruments => [{
  #                                                                                :credit_card => {
  #                                                                                    :type => "visa",
  #                                                                                    :number => "4567516310777851",
  #                                                                                    :expire_month => "11",
  #                                                                                    :expire_year => "2018",
  #                                                                                    :cvv2 => "874",
  #                                                                                    :first_name => "Joe",
  #                                                                                    :last_name => "Shopper",
  #                                                                                    :billing_address => {
  #                                                                                        :line1 => "52 N Main ST",
  #                                                                                        :city => "Johnstown",
  #                                                                                        :state => "OH",
  #                                                                                        :postal_code => "43210",
  #                                                                                        :country_code => "US"}}}]},
  #                                               :transactions => [{
  #                                                                     :item_list => {
  #                                                                         :items => [{
  #                                                                                        :name => "item",
  #                                                                                        :sku => "item",
  #                                                                                        :price => "1",
  #                                                                                        :currency => "USD",
  #                                                                                        :quantity => 1}]},
  #                                                                     :amount => {
  #                                                                         :total => "1.00",
  #                                                                         :currency => "USD"},
  #                                                                     :description => "This is the payment transaction description."}]})
  # @payment.create
  # @sale = PayPal::SDK::REST::DataTypes::Sale.find '0KN32949AS9765432'
  # @refund = @sale.refund_request({})
  # or
  # @refund = @sale.refund_request({
  #     :amount => {
  #         :total => "1.31",
  #         :currency => "USD"
  #     }
  # })

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
    @refund = @sale.refund_request({
                                       :amount => {
                                           :total => "1",
                                           :currency => "USD"
                                       }
                                   })
    firebase = Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')
    fcm = params[:fcm]
    firebase.delete("rejectedOrder/#{fcm}")
    redirect_to home_path
  end
end
