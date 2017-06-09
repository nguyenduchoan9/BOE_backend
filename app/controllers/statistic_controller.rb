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
        duration = params[:duration]
        if type == 'user'
          if duration == 'month'
            render json: User.includes(:role).group('roles.name').references(:roles).where('date_part(\'month\', users.created_at) = date_part(\'month\', current_date)').count.to_json
          elsif duration == 'year'
            render json: User.includes(:role).group('roles.name').references(:roles).where('date_part(\'year\', users.created_at) = date_part(\'year\', current_date)').count.to_json
          else

          end
        elsif type == 'order'
          if duration == 'month'
            render json: Order.includes(:user).group('users.username').select('users.username').references(:users).where('date_part(\'month\', orders.created_at) = date_part(\'month\', current_date)').sum(:total).to_json
          elsif duration == 'year'
            render json: Order.includes(:user).group('users.username').select('users.username').references(:users).where('date_part(\'year\', orders.created_at) = date_part(\'year\', current_date)').sum(:total).to_json
          else

          end
        else
          if duration == 'month'
            render json: OrderDetail.includes(:dish).group('dishes.dish_name').references(:dishes).where('date_part(\'month\', orders.created_at) = date_part(\'month\', current_date)').sum(:quantity).to_json
          elsif duration == 'year'
            render json: OrderDetail.includes(:dish).group('dishes.dish_name').references(:dishes).where('date_part(\'year\', orders.created_at) = date_part(\'year\', current_date)').sum(:quantity).to_json
          else

          end
        end
      }
    end
  end
end
