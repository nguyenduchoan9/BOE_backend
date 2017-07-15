class SessionController < WebApplcationController
    include ConfigBoeHelper
    before_action 'check_session', only: :new

    def check_session
        if !session[:user_id].nil?
            redirect_to users_path
        end
    end

    def new
        find_or_creata_membership_point 'silver', 100
        ab = get_membership_by_name 'silver'
        byebug
    end

    def create
        user_password = params[:session][:password]
        user_username = params[:session][:username]
        user = user_username.present? && User.find_by(username: user_username)
        if user.present?
            if user.valid_password? user_password
                sign_in user, store: false
                if user.role.name == 'admin' || user.role.name == 'manager'
                    session[:user_id] = user.id
                    current_user = User.find user.id
                    session[:full_name] = current_user.full_name
                    session[:email] = current_user.email
                    session[:avatar] = current_user.avatar
                    session[:role] = current_user.role.name
                    redirect_to root_path
                else
                    redirect_to login_path
                end
            else
                flash.now.alert = 'Email or password is invalid'
                render :new
            end
        else
            render :new
        end
    end

    def destroy
        reset_session
        render 'new'
    end

    def session_params
        params.require(:session).permit(:username, :password)
    end
end
