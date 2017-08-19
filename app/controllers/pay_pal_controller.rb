class PayPalController < ApplicationController
  add_breadcrumb "Home", :root_path

  def cancel_order
    order_details = OrderDetail.find params[:order_detail_id]
    if order_details.order.payment_method == 0
      PayPal::SDK.configure(
          :mode => "sandbox", # "sandbox" or "live"
          :client_id => "AetzVQhJh6kV_v_GDex0IynGO_6ky0VLzvF0D3akJ7YDCVGYSrgTpIW-FAq-AdYlVW0TMJ7XdYpbCPz-",
          :client_secret => "EP-HvkNBWll71g9q2PKfTDtWXQ0T-Nwx5_v4AXsdSeeq-Y0IChsauzdMGTriTWrD0Vi8uMclrC5shTpe",
          :ssl_options => {})
      payment_id = order_details.order.payment_id
      payment = PayPal::SDK::REST::DataTypes::Payment.find payment_id
      json = JSON.parse payment.to_json
      @sale = PayPal::SDK::REST::DataTypes::Sale.find json["transactions"][0]["related_resources"][0]["sale"]["id"]
      json = JSON.parse HTTParty.get("http://apilayer.net/api/live?access_key=088bcad87c3fd862b4793c2f535089ba").to_json
      rate = json["quotes"]["USDVND"].to_f
      total = (order_details.price * order_details.quantity_not_serve)
      usdTotal = (total.to_f / rate).round(2)
      @refund = @sale.refund_request({
                                         :amount => {
                                             :total => "#{'%.02f' % usdTotal}",
                                             :currency => "USD"
                                         }
                                     })
    else
      total = (order_details.price * order_details.quantity_not_serve)
      order_details.order.user.balance += total
      order_details.order.user.save!
    end
    order_details.order.total -= total
    order_details.order.save!
    order_details.cooking_status = 4
    order_details.save!
    allowance = Allowance.new
    allowance.order_id = order_details.order.id
    allowance.total = total
    allowance.save!
    notify_chef_cancel_dish [params[:order_detail_id]]

    user_id = order_details.order.user_id
    notify_to_user user_id, params[:order_detail_id], total
    redirect_to current_order_path(term: params[:term], type: params[:type])
  end

  def notify_chef_cancel_dish od_ids
    NotificationWorker.perform_async(Constant::CHEF, od_ids, 0, 2, 0)
  end

  def notify_to_user user_id, order_details_ids, total_refund
    NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 2, total_refund)
  end

  def executeSend
    order = Order.find params[:order_id]
    if order.payment_method == 0
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
    else
      order.user.balance += params[:amount].to_i
      order.user.save!
    end
    allowance = Allowance.new
    allowance.order_id = order.id
    allowance.total = params[:amount]
    allowance.note = params[:note].to_s.squish!
    allowance.save!
    NotificationWorker.perform_async(Constant::DINER, allowance.id, order.user_id, 4, 0)
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
    allowance.total = params[:amount]
    allowance.save!
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
    allowance.total = params[:amount]
    allowance.save!
  end

  # def refund
  #   PayPal::SDK.configure(
  #       :mode => "sandbox", # "sandbox" or "live"
  #       :client_id => "AetzVQhJh6kV_v_GDex0IynGO_6ky0VLzvF0D3akJ7YDCVGYSrgTpIW-FAq-AdYlVW0TMJ7XdYpbCPz-",
  #       :client_secret => "EP-HvkNBWll71g9q2PKfTDtWXQ0T-Nwx5_v4AXsdSeeq-Y0IChsauzdMGTriTWrD0Vi8uMclrC5shTpe",
  #       :ssl_options => {})
  #   order_id = params[:order_id]
  #   order = Order.find order_id
  #   total = 0
  #   ods = []
  #   order.order_details.where(cooking_status: 3).each do |order_detail|
  #     ods << order_detail.id
  #     total += (order_detail.price.to_f * order_detail.quantity_not_serve.to_f)
  #   end
  #   payment_id = order.payment_id
  #   payment = PayPal::SDK::REST::DataTypes::Payment.find payment_id
  #   json = JSON.parse payment.to_json
  #   @sale = PayPal::SDK::REST::DataTypes::Sale.find json["transactions"][0]["related_resources"][0]["sale"]["id"]
  #   json = JSON.parse HTTParty.get("http://apilayer.net/api/live?access_key=088bcad87c3fd862b4793c2f535089ba").to_json
  #   rate = json["quotes"]["USDVND"].to_f
  #   usdTotal = (total.to_f / rate).round(2)
  #   @refund = @sale.refund_request({
  #                                      :amount => {
  #                                          :total => "#{'%.02f' % usdTotal}",
  #                                          :currency => "USD"
  #                                      }
  #                                  })
  #   order.order_details.where(cooking_status: 3).each do |order_detail|
  #     order_detail.cooking_status = 4
  #     order_detail.save!
  #   end
  #   # byebug
  #   notify_to_user order.user_id, ods, total
  #   redirect_to rejected_order_path(term: order.created_at.strftime('%d/%m/%Y'))
  # end

  def send_money
    add_breadcrumb "Send Money"
    if (params[:username].nil? || params[:username] == "") && !params[:term].nil?
      @orders = Order.where("DATE(created_at) = ?", "#{params[:term]}")
    elsif (params[:term].nil? || params[:term] == "") && !params[:username].nil?
      puts params[:username]
      @orders = User.find_by(username: params[:username]).orders
    elsif !params[:term].nil? && !params[:username].nil?
      @orders = User.find_by(username: params[:username]).orders.where("DATE(created_at) = ?", "#{params[:term]}")
    end


  end

  def getEmail
    order_id = params[:order_id]
    order = Order.find order_id
    if order.payment_method == 0
      PayPal::SDK.configure(
          :mode => "sandbox", # "sandbox" or "live"
          :client_id => "AetzVQhJh6kV_v_GDex0IynGO_6ky0VLzvF0D3akJ7YDCVGYSrgTpIW-FAq-AdYlVW0TMJ7XdYpbCPz-",
          :client_secret => "EP-HvkNBWll71g9q2PKfTDtWXQ0T-Nwx5_v4AXsdSeeq-Y0IChsauzdMGTriTWrD0Vi8uMclrC5shTpe",
          :ssl_options => {})
      payment = PayPal::SDK::REST::DataTypes::Payment.find order.payment_id
      json = JSON.parse payment.to_json
      email = json["payer"]["payer_info"]["email"]
    else
      email = order.user.username
    end
    render json: {email: email, order_id: order_id}
  end
end
