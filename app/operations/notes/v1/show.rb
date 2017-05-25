module Notes
  module V1
    class Show < Operation
      require_authen!

      def process
        authorize!(note)
        Notes::Serializer.new(note)
      end

      private
      def note
        puts id_param
        user.note.find(id_param)
      end

      def id_param
        params[:id]
      end

      def user
        @user
      end
    end
  end
end
