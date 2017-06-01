class WebApplcationController < ApplicationController
  # before_action :configure_permitted_parameters, if: :devise_controller?
  #
  # protected
  #
  # def configure_permitted_parameters
  #   devise_paritameter_sanitizer.permit(:sign_up, keys: [:username])
  # end
  def authen_user
        if session[:user_id].nil?
            redirect_to login_path
        end
    end
end
