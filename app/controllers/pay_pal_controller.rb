class PayPalController < ApplicationController
  add_breadcrumb "Home", :root_path

  def executeSend
    PayPal::SDK.configure(
        :mode => "sandbox", # "sandbox" or "live"
        :client_id => "AetzVQhJh6kV_v_GDex0IynGO_6ky0VLzvF0D3akJ7YDCVGYSrgTpIW-FAq-AdYlVW0TMJ7XdYpbCPz-",
        :client_secret => "EP-HvkNBWll71g9q2PKfTDtWXQ0T-Nwx5_v4AXsdSeeq-Y0IChsauzdMGTriTWrD0Vi8uMclrC5shTpe",
        :ssl_options => {})
    total = params[:amount]
    json = JSON.parse HTTParty.get("http://apilayer.net/api/live?access_key=088bcad87c3fd862b4793c2f535089ba").to_json
    rate = json["quotes"]["USDVND"].to_f
    usdTotal = (total.to_f / rate).round(2)
    @payout = PayPal::SDK::REST::DataTypes::Payout.new(
        {
            :sender_batch_header => {
                :sender_batch_id => SecureRandom.hex(8),
                :email_subject => 'You have a Payout!',
            },
            :items =>
                {
                    :recipient_type => 'EMAIL',
                    :amount => {
                        :value => "#{'%.02f' % usdTotal}",
                        :currency => 'USD'
                    },
                    :note => "#{params[:note].to_s.squish!}",
                    :receiver => "#{params[:receiverEmail]}",
                    :sender_item_id => "2014031400023",
                }

        }
    )
    @payout.create
    redirect_to send_money_path
  end

  def notify_webapp
    firebase = Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')
    list_orderdetail_id = params[:list_orderdetail_id].split('_')
    list_orderdetail_id.each do |order_detail_id|
      orderdetail = OrderDetail.find order_detail_id
      firebase.push("rejectedOrder", {tableNumber: "#{orderdetail.order.table_number}", status: 'new', dishName: "#{orderdetail.dish.dish_name}", price: "#{orderdetail.price}", quantity: "#{orderdetail.quantity_not_serve}", order_detail_id: "#{orderdetail.id}"})
    end
    render nothing: true
  end

  def rejected_order
    add_breadcrumb "Rejected Orders"
    if !params[:term].nil?
      order_id = OrderDetail.select(:order_id).where('cooking_status = 3 AND  DATE(created_at) = ?', "#{params[:term]}").group(:order_id).map(&:order_id)
      @orders = Order.find order_id
      # @order_details = OrderDetail.where('cooking_status = 3 AND  DATE(created_at) = ?', "#{params[:term]}")
    else
      order_id = OrderDetail.select(:order_id).where('cooking_status = 3 AND  DATE(created_at) = ?', "#{Date.today}").group(:order_id).map(&:order_id)
      @orders = Order.find order_id
      params[:term] = Date.today.strftime('%d/%m/%Y')
    end
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
    ods = []
    order.order_details.where(cooking_status: 3).each do |order_detail|
      ods << order_detail
      total += (order_detail.price.to_f * order_detail.quantity_not_serve.to_f)
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
    notify_to_user order.user_id, ods, total
    redirect_to rejected_order_path(term: order.created_at.strftime('%d/%m/%Y'))
  end

  def notify_to_user user_id, order_details_ids, total
    NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 1, total)
  end

  def send_money
    add_breadcrumb "Send Money"
    if !params[:term].nil?
      @orders = Order.where("DATE(created_at) = ?", "#{params[:term]}")
    end
  end

  def getEmail
    order_id = params[:order_id]
    order = Order.find order_id
    PayPal::SDK.configure(
        :mode => "sandbox", # "sandbox" or "live"
        :client_id => "AetzVQhJh6kV_v_GDex0IynGO_6ky0VLzvF0D3akJ7YDCVGYSrgTpIW-FAq-AdYlVW0TMJ7XdYpbCPz-",
        :client_secret => "EP-HvkNBWll71g9q2PKfTDtWXQ0T-Nwx5_v4AXsdSeeq-Y0IChsauzdMGTriTWrD0Vi8uMclrC5shTpe",
        :ssl_options => {})
    payment = PayPal::SDK::REST::DataTypes::Payment.find order.payment_id
    json = JSON.parse payment.to_json
    email = json["payer"]["payer_info"]["email"]
    puts email
    render json: {email: email}
  end
end