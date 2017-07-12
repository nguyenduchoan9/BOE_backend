class DishesController < ApplicationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Dishes", :dishes_path

  def create
    @dish = Dish.new dish_params
    @dish.is_available = true
    @dish.save
    if params["isSocial"] == "on"
      me = FbGraph::User.me('EAACEdEose0cBAD9N8nLuszpOzuy3wEpek93PCZBZC9y8dxC33zJDb0DDqlDNLOXMWAFJBQPZCQIg5VlPhLc32gRhgYCZAV9UnUdgRDliQM6fjv8U4VcHB76KZAVIwol2WviI12qlfdO1vrQAVlxY4gbql9uao9ZCZC0K0EwGXGgSZAMEZBr3ytZAykAP2ADal4DbJF7poQWYzwqQZDZD')
      me.feed!(
          :message => "#{@dish.description}",
          :picture => 'https://graph.facebook.com/matake/picture',
          :link => 'https://github.com/nov/fb_graph',
          :name => "#{@dish.dish_name}",
          :description => "#{@dish.created_at.to_date}"
      )
    end
    redirect_to dishes_path
  end

  def show
    if !params[:term].nil? && params[:term] != ''
      @dishes = Dish.search(params[:term]).paginate(page: params[:page], per_page: 10)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @dish = Dish.new
    add_breadcrumb "New Dish"
  end

  def update_status
    respond_to do |format|
      format.json {
        @dish = Dish.find params[:id]
        if @dish.is_available.nil?
          @dish.update is_available: false
        end
        @dish.update is_available: !@dish.is_available
        render nothing: ''
      }
    end
  end

  def edit
    @dish = Dish.find params[:id]
    add_breadcrumb @dish.dish_name
  end

  def update
    @dish = Dish.find params[:dish][:id]
    @dish.update_attributes(dish_params)
    redirect_to action: 'show'
  end

  private
  def dish_params
    params.require(:dish).permit :id, :description, :dish_name, :category_id, :image, :status, :term, :material_id, :isSocial
  end
end
