module Notes
  module V1
    class Index < Operation
      require_authen!

      def process
        user.note.where(user_id: user.id).to_a
      end

      private
      def user
        @user
      end
    end
  end
end
