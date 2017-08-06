class DishesController < ApplicationController
    before_action 'authen_user'
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Dishes", :dishes_path

    def create
        @dish = Dish.new dish_params
        @dish.is_available = true
        @dish.save
        if params["isSocial"] == "on"
            me = FbGraph::User.me('EAACEdEose0cBAFOzH62V058gbJKX6LZB7VSWzCu5ijclr3ZBUBiaBcCCIvF6gZA4xKVw85eyazpo0jE8JXiuGhZCJqSRE4xKDCLb8oEo2MtstXMB6G8csZAmsfeTOZASC4pHKKPifiKR8rf5vxAgF3O17VZBX4qA2bhobV0K6ujQtyaAhBSQFx7u3F1TRoEZC7ZCxd3uFZBxVkxQZDZD')
            me.photo!(
                :source => File.new("#{@dish.image.file.file}", 'rb'), # 'rb' is needed only on windows
                :message => "#{@dish.description}"
            )
            # me.feed!(
            #     :message => "#{@dish.description}",
            #     :picture => 'https://graph.facebook.com/matake/picture',
            #     :link => 'https://github.com/nov/fb_graph',
            #     :name => "#{@dish.dish_name}",
            #     :description => "#{@dish.category.category_name}"
            # )
        end
        @price = PriceChangeHistory.new
        @price.dish_id = @dish.id
        @price.from_date = Date.today
        @price.price = params[:price]
        @price.save!
        redirect_to dishes_path
    end

    def show
        if !params[:term].nil? && params[:term] != ''
            @dishes = Dish.search_by_phong(params[:term]).paginate(page: params[:page], per_page: 10)
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

    def edit
        @dish = Dish.find params[:id]
        add_breadcrumb @dish.dish_name
    end

    def update
        @dish = Dish.find params[:dish][:id]
        @dish.update_attributes(dish_params)
        @price = PriceChangeHistory.new
        @price.dish_id = @dish.id
        @price.price = params[:price]
        @price.from_date = Date.today
        @price.save!
        redirect_to action: 'show'
    end

    private
    def dish_params
        params.require(:dish).permit :id, :description, :dish_name, :category_id, :image, :status, :term, :material_id, :isSocial, :price
    end
end
