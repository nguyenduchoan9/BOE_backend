module Users
    module V1
        class Balance < Operation
            require_authen!

            def process
                {balance: balance}
            end

            private
            def balance
                user.balance
            end
            def user
                @user ||= User.find_by(id: user_params)
            end

            def user_params
                params[:id]
            end
        end
    end
end
