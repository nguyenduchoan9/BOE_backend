module Notifications
    module V1
        class RegisterRegToken < Operation
            include ApplicationHelper
            require_authen!

            def process
                user.reg_token = token_params
                user.save!
                {:status => true}
            end

            private
            def token_params
                params.permit[:reg_token]
            end
        end
    end
end
