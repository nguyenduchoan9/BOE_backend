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
    # @user.update_attributes(:username => params[:user][:username], :password => params[:user][:password], full_name: params[:user][:full_name], role: Role.find(params[:user][:role_id]), membership: Membership.find(params[:user][:membership_id]), email: params[:user][:email], phone: params[:user][:phone], birthdate: params[:user][:birthdate].to_date)
    @dish.update_attributes(dish_name: params[:dish][:dish_name], description: params[:dish][:description], category_id: params[:dish][:category_id])
    redirect_to action: 'show'
  end

  private
  def dish_params
    params.require(:dish).permit :id, :description, :dish_name, :category_id
  end
end
