class UsersController < WebApplcationController

  def index

  end

  def show
    @users = User.search(params[:term]).paginate(page: params[:page], per_page: 5)
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:user][:id]
    @user.update_attributes(:username => params[:user][:username], :password => params[:user][:password], fullname: params[:user][:fullname], roleid: params[:user][:roleid])
    redirect_to action: 'show'
  end


end
