class StatisticController < WebApplcationController
  before_action 'authen_user'

  def index
    @user = Order.order('sum_total desc').includes(:user).group('users.username').select('users.username').references(:users).sum(:total).first
    @dish = OrderDetail.order('sum_quantity desc').includes(:dish).group('dishes.dish_name').references(:dishes).sum(:quantity).first
    @revenue = Order.sum(:total)
    @visit = Order.count
  end

  def make_statistic
    respond_to do |format|
      format.html {

      }
      format.json {
        type = params[:type]
        duration = params[:duration]
        if type == 'user'
          if duration == 'month'
            render json: Order.order('sum_total').includes(:user).group('users.username').select('users.username').references(:users).where('date_part(\'month\', orders.created_at) = date_part(\'month\', current_date)').sum(:total).first(10).to_json
          elsif duration == 'year'
            render json: Order.order('sum_total').includes(:user).group('users.username').select('users.username').references(:users).where('date_part(\'year\', orders.created_at) = date_part(\'year\', current_date)').sum(:total).first(10).to_json
          else

          end
        elsif type == 'order'
          if duration == 'month'
            render json: Order.where('date_part(\'month\', orders.created_at) = date_part(\'month\', current_date)').group_by_day_of_week(:created_at, format: "%a").sum(:total).to_json
          elsif duration == 'year'
            render json: Order.where('date_part(\'year\', orders.created_at) = date_part(\'year\', current_date)').group_by_month(:created_at, format: "%b %Y").sum(:total).to_json
          else

          end
        else
          if duration == 'month'
            render json: OrderDetail.includes(:dish).group('dishes.dish_name').references(:dishes).where('date_part(\'month\', order_details.created_at) = date_part(\'month\', current_date)').sum(:quantity).first(5).to_json
          elsif duration == 'year'
            render json: OrderDetail.includes(:dish).group('dishes.dish_name').references(:dishes).where('date_part(\'month\', order_details.created_at) = date_part(\'month\', current_date)').sum(:quantity).first(5).to_json
          else

          end
        end
      }
    end
  end
end
