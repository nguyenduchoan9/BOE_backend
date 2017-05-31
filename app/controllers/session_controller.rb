class SessionController < WebApplcationController

  def new

  end

  def create
    # user = User.find_by(username: params[:session][:username])
    #
    user_password = params[:session][:password]
    user_username = params[:session][:username]
    user = user_username.present? && User.find_by(username: user_username)
    if user.valid_password? user_password
      sign_in user, store: false
      session[:user_id] = user.id
      render text: 'admin' if user.role.name == 'admin'
      render text: 'diner' if user.role.name == 'diner'
      # render text: 'diner' if user.role.name == 'diner'
    else
      flash.now.alert = 'Email or password is invalid'
      render :new
    end
  end

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
