module Users
  module V1
    class Update < Operation
      
      require_authen!

      def process
        if user.update(user_params)
          Users::Serializer.new(user)
        else
          raise ValidateError.new(user.errors)
        end

        private
        def user
          @user 
        end

        def user_params
          params.permit(
            :first_name,
            :last_name,
            :email,
            :password
          )
        end
      end
    end
  end
end
