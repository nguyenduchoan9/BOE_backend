class VouchersController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Vouchers", :vouchers_path

  def show
    if !params[:vouchers].nil? && params[:vouchers] != ''
      @vouchers = Voucher.where(id: params[:vouchers]).paginate(page: params[:page], per_page: 10)
    end

  end

  def create
    @vouchers = Voucher.generate params[:quantity].to_i, params[:amount]
    redirect_to vouchers_path(vouchers: @vouchers)
  end
end
