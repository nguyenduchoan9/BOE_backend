class StatisticController < WebApplcationController
  before_action 'authen_user'

  def index
  end

  def make_statistic
    @users = User.all
    respond_to do |format|
      format.html
      format.js {}
      format.json {
        type = params[:type]
        from_date = params[:from_date]
        to_date = params[:to_date]
        if type == 'user'
          render json: User.group('role_id').count.to_json
        else
          if type == 'order'
            render json: Order.group('DATE(created_at)').count.to_json
          else
            render json: Dish.group('category_id').count.to_json
          end
        end
      }
    end
  end
end
