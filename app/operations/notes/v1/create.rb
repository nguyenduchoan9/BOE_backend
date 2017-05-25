module Notes
  module V1
    class Create < Operation
      require_authen!

      def process
        note = user.note.new(note_params)
        raise ValidateError.new(note.errors) unless note.save
        Notes::Serializer.new(note)
      end

      private
      def user
        @user
      end

      def note_params
        params.permit(:title, :body)
      end
    end
  end
end
