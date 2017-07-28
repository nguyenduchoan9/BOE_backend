class ApplicationController < ActionController::Base
    include ActionView::Helpers::NumberHelper

    def authen_user
        if session[:user_id].nil?
            redirect_to login_path
        end
    end
end
