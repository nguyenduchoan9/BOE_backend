class ApplicationController < ActionController::Base
    # base_uri = 'https://boebackend.firebaseio.com'
    #
    # firebase = Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')

    # response = firebase.push("todos", { :name => 'Pick the milk', :priority => 1 })

    def authen_user
        if session[:user_id].nil?
            redirect_to login_path
        end
    end
end
