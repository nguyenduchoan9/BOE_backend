class DiscountDaysController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Discounts", :discount_days_path

  def show
    if !params[:term].nil? && params[:term] != ''
      @discount_days = DiscountDay.search(params[:term]).paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @discount_day = DiscountDay.new
  end

  def create
    @discount_day = DiscountDay.new discount_day_params
    @discount_day.save
    redirect_to discount_days_path
  end

  def edit
    @discount_day = DiscountDay.find params[:id]
    add_breadcrumb "Discount Day "+ params[:id]
  end

  def update
    @discount_day = DiscountDay.find params[:discount_day][:id]
    @discount_day.update_attributes(discount_day_params)
    redirect_to discount_days_path
  end

  private
  def discount_day_params
    params.require(:discount_day).permit :id, :name, :from_day, :to_day, :discount_item, :discount_rate, :image
  end
end
