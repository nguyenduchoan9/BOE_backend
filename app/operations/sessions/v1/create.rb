module Sessions
  module V1
    class Create < Sessions::Base
      class InvalidEmailOrPassword < ValidateError
        def code
          'INVALID_EMAIL_PASSWORD'
        end
      end

      private
      def find_user
        user = User.find_by(:uid => uid, :provider => provider)
        if user && user.valid_password?(password)
        	user
        else
        	raise InvalidEmailOrPassword
        end
      end

      def provider
        'email'
      end

      def uid
        params[:email]
      end

      def password
        params[:password]
      end
    end
  end
end
