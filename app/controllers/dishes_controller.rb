class DishesController < ApplicationController
  before_action 'authen_user'

  def new
    @dish = Dish.new

  end

  def create
    @dish = Dish.new dish_params
    @dish.save
    redirect_to dishes_path
  end

  def show
    @dishes = Dish.all
  end

  def edit
    @dish = Dish.find params[:id]
  end

  def update
    @dish = Dish.find params[:dish][:id]
    @dish.update_attributes(dish_name: params[:dish][:dish_name], description: params[:dish][:description], category_id: params[:dish][:category_id], image: params[:dish][:image])
    redirect_to action: 'show'
  end

  private
  def dish_params
    params.require(:dish).permit :id, :description, :dish_name, :category_id, :image
  end
end
