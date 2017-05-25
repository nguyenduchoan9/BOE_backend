module Notes
  module V1
    class Update < Operation
      require_authen!

      def process
        authorize!(note)
        note.update!(note_param)
        Notes::Serializer.new(note)
      end

      private
      def note
        Note.find(params[:id])
      end

      def note_param
        params.permit(:title, :body, :status)
      end
    end
  end
end
