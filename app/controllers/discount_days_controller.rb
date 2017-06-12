class DiscountDaysController < ApplicationController
  before_action 'authen_user'

  def show
    @discount_days = DiscountDay.all
  end

  def create
    @discount_day = DiscountDay.new discount_day_params
    @discount_day.save
    redirect_to discount_days_path
  end

  def edit
    @discount_day = DiscountDay.find params[:id]
  end

  def update
    @discount_day = DiscountDay.find params[:discount_day][:id]
    @discount_day.update_attributes(name: params[:discount_day][:name], from_day: params[:discount_day][:from_day], to_day: params[:discount_day][:to_day], discount_item: params[:discount_day][:discount_item], discount_rate: params[:discount_day][:discount_rate], image: params[:discount_day][:image])
    redirect_to discount_days_path
  end

  private
  def discount_day_params
    params.require(:discount_day).permit :id, :name, :from_day, :to_day, :discount_item, :discount_rate, :image
  end
end
