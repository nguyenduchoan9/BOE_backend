class ApplicationController < ActionController::Base
    # base_uri = 'https://boebackend.firebaseio.com'
    # firebase = Firebase::Client.new('https://boebackend.firebaseio.com', 'FpE63dhjckc4wr6w5wGyRATrYlkEXJ3b5EJOwaGI')
    # response = firebase.push("Phongdemo", { username: 'pphong', status: 'new', orderdetail: 'Order Item' })

    # fcm = FCM.new("AIzaSyDrFf5420hhnSDQ_attRZLC-57O5ahVHBw")
    # registration_ids= ["cUd8y0jRSM0:APA91bF1vQG3KrAZkzZm1peAO322RLnPd7943shQQEqMWP5ub0qIT8Td9mXIoUfTc9n-Ni85LGqwRfkI38sYk2kT-ff_Z5XVfMNzZF6vaFipZ4nPrUN4qef5msZHIkeDqBae3-bfvz_3"]
    # options = {data: {score: "123"}, collapse_key: "updated_score"}
    # fcm.send(registration_ids, options)
    # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    def authen_user
        if session[:user_id].nil?
            redirect_to login_path
        end
    end
end
