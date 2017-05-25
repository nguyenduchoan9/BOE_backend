module Users
  module V1
    class Create < Operation
      def process
        user = User.new(user_params)
        user.role_id = role.id
        raise ValidateError.new(user.errors) unless user.save
        result.new(
          Users::Serializer.new(user),
          user.create_new_auth_token
        )
      end

      private
      def role
        Role.find_by(:name => 'user')
      end

      def user_params
        params.permit(
          :first_name,
          :last_name,
          :email,
          :password,
          :password_confirmation
        )
      end

      def result
        Struct.new(:body, :header)
      end
    end
  end
end
