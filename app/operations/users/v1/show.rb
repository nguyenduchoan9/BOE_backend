module Users
  module V1
    class Show < Operation
      require_authen!

      def process
        Users::Serializer.new(user)
      end
      
      private
      def user
        @user ||= User.find_by(id: user_params)
      end

      def user_params
      	params.permit(:id)
      end
    end
  end
end
