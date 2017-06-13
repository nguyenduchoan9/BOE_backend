class DishesController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Dishes", :dishes_path

  def create
    @dish = Dish.new dish_params
    @dish.save
    redirect_to dishes_path
  end

  def show
    @dishes = Dish.all
    respond_to do |format|
      format.html
      format.json
    end
  end

  def edit
    @dish = Dish.find params[:id]
    add_breadcrumb "Dish "+ params[:id]
  end

  def update
    @dish = Dish.find params[:dish][:id]
    @dish.update_attributes(dish_name: params[:dish][:dish_name], description: params[:dish][:description], category_id: params[:dish][:category_id], image: params[:dish][:image], status: params[:dish][:status])
    redirect_to action: 'show'
  end

  private
  def dish_params
    params.require(:dish).permit :id, :description, :dish_name, :category_id, :image, :status
  end
end
