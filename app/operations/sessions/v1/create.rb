module Sessions
  module V1
    class Create < Sessions::Base
      class InvalidUsernameOrPassword < ValidateError
        def code
          'INVALID_USERNAME_PASSWORD'
        end
      end

      private
      def find_user
        user = User.find_by(:username => username, :provider => provider)
        if user && user.valid_password?(password)
        	user
        else
        	raise InvalidUsernameOrPassword
        end
      end

      def provider
        'email'
      end

      def username
        params[:username]
      end

      def password
        params[:password]
      end
    end
  end
end
