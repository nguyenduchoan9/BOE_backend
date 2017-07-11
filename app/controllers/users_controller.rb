class UsersController < WebApplcationController
  before_action 'authen_user'
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Users", :users_path

  def new
    @user = User.new
    add_breadcrumb "New User"
  end

  def create
    @user = User.new user_params

    @user.save
    redirect_to users_path
  end

  def show
    if !params[:term].nil? && params[:term] != ''
      @users = User.search(params[:term]).paginate(page: params[:page], per_page: 10)
    end
  end

  def edit
    @user = User.find params[:id]
    add_breadcrumb @user.username
  end

  def update
    @user = User.find params[:user][:id]
    @user.update_attributes(user_params)
    redirect_to action: 'show'
  end

  def user_params
    params.require(:user).permit :id, :username, :full_name, :role_id, :membership_id, :email, :phone, :birthdate, :avatar, :term, :password, :password_confirmation
  end
end
