class PayPalController < ApplicationController
  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = "t96gbj9c6z2kppx3"
  Braintree::Configuration.public_key = "56t58d9t9yffs94m"
  Braintree::Configuration.private_key = "8d1ffcc94df3e2d21f61e59fc371abd5"

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

  def payment(amount)
    result = Braintree::Transaction.sale(
        :amount => amount,
        :payment_method_nonce => 'fake-valid-nonce',
        :options => {
            :submit_for_settlement => true
        }
    )
  end
end
