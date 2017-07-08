class PayPalController < ApplicationController
  # Braintree::Configuration.environment = :sandbox
  # Braintree::Configuration.merchant_id = "t96gbj9c6z2kppx3"
  # Braintree::Configuration.public_key = "56t58d9t9yffs94m"
  # Braintree::Configuration.private_key = "8d1ffcc94df3e2d21f61e59fc371abd5"
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


  # result = Braintree::Transaction.sale(
  #     :amount => '27.00',
  #     :payment_method_nonce => 'fake-valid-nonce',
  #     :options => {
  #         :submit_for_settlement => true
  #     }
  # )

  # result = Braintree::Transaction.refund("transactions_id")

  # search_results = Braintree::Transaction.search do |search|
  #   search.settled_at >= Time.now - 60*60*24 # a day ago
  # end

  def refund(sale_id)
    @sale = PayPal::SDK::REST::DataTypes::Sale.find "#{sale_id}"
    @refund = @sale.refund_request({})
  end
end
