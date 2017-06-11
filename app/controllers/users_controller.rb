class UsersController < WebApplcationController
  before_action 'authen_user'

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
  end

  def update
    @user = User.find params[:user][:id]
    @user.update_attributes(:username => params[:user][:username], :password => params[:user][:password], full_name: params[:user][:full_name], role: Role.find(params[:user][:role_id]), membership: Membership.find(params[:user][:membership_id]), email: params[:user][:email], phone: params[:user][:phone], birthdate: params[:user][:birthdate].to_date)
    redirect_to action: 'show'
  end

end
