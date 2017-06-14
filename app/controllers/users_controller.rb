class UsersController < WebApplcationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Users", :users_path

  def new
    @user = User.new
  end

  def create
  end

  def show
    @users = User.all
  end

  def edit
    @user = User.find params[:id]
    add_breadcrumb "User "+ params[:id]
  end

  def update
    @user = User.find params[:user][:id]
    @user.update_attributes(user_params)
    redirect_to action: 'show'
  end

  def user_params
    params.require(:user).permit :id, :username, :full_name, :role_id, :membership_id, :email, :phone, :birthdate, :avatar
  end
end
