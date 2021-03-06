class PriceChangeHistoriesController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Price", :price_change_histories_path

  def new
    @price_change_history = PriceChangeHistory.new
    add_breadcrumb "New Price"
  end

  def show
    if !params[:term].nil? && params[:term] != ''
      @price_change_histories = PriceChangeHistory.search(params[:term]).paginate(page: params[:page], per_page: 10)
    end
  end

  def create
    @price_change_history = PriceChangeHistory.new price_history_params
    @price_change_history.save
    redirect_to price_change_histories_path
  end

  def edit
    @price_change_history = PriceChangeHistory.find params[:id]
    add_breadcrumb @price_change_history.dish.dish_name
  end

  def update
    @price_change_history = PriceChangeHistory.find params[:price_change_history][:id]
    @price_change_history.update_attributes(price_history_params)
    redirect_to price_change_histories_path
  end

  private
  def price_history_params
    params.require(:price_change_history).permit :dish_id, :price, :from_date
  end
end
