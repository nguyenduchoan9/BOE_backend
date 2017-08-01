class StatisticController < WebApplcationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  include ConfigBoeHelper

  def current_order
    add_breadcrumb "Current Orders"
    if !params[:term].nil?
      @orders = Order.where(table_number: params[:term])
    end
  end

  def home
    if session[:role] == 'admin'
      redirect_to users_path
    end
  end

  def scheduler
    add_breadcrumb "Scheduler"
  end

  def index
    @user = Order.order('sum_total desc').includes(:user).group('users.username').select('users.username').references(:users).sum(:total).first
    @dish = OrderDetail.order('sum_quantity desc').includes(:dish).group('dishes.dish_name').references(:dishes).sum(:quantity).first
    @revenue = Order.sum(:total)
    @visit = Order.count
    add_breadcrumb "Dashboard"
  end

  def setScheduler
    closeTime = params[:closeTime]
    if closeTime != ''
      set_time_close closeTime.split(':')[0], closeTime.split(':')[1]
      render json: {status: 'true'}
    else
      render nothing: true
    end
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
            render json: Order.order('sum_total desc').includes(:user).group('users.username').select('users.username').references(:users).where('date_part(\'month\', orders.created_at) = date_part(\'month\', current_date)').sum(:total).first(10).to_json
          elsif duration == 'year'
            render json: Order.order('sum_total desc').includes(:user).group('users.username').select('users.username').references(:users).where('date_part(\'year\', orders.created_at) = date_part(\'year\', current_date)').sum(:total).first(10).to_json
          else

          end
        elsif type == 'order'
          if duration == 'month'
            render json: Order.order('sum_total desc').where('date_part(\'month\', orders.created_at) = date_part(\'month\', current_date)').group_by_day_of_week(:created_at, format: "%a").sum(:total).to_json
          elsif duration == 'year'
            render json: Order.order('sum_total desc').where('date_part(\'year\', orders.created_at) = date_part(\'year\', current_date)').group_by_month(:created_at, format: "%b %Y").sum(:total).to_json
          else

          end
        else
          if duration == 'month'
            render json: OrderDetail.order('sum_quantity desc').includes(:dish).group('dishes.dish_name').references(:dishes).where('date_part(\'month\', order_details.created_at) = date_part(\'month\', current_date)').sum(:quantity).first(5).to_json
          elsif duration == 'year'
            render json: OrderDetail.order('sum_quantity desc').includes(:dish).group('dishes.dish_name').references(:dishes).where('date_part(\'year\', order_details.created_at) = date_part(\'year\', current_date)').sum(:quantity).first(5).to_json
          else

          end
        end
      }
    end
  end
end
