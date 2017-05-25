module Notes
  module V1
    class Destroy < Operation
      require_authen!

      def process
        authorize!(note)
        note.destroy!
      end

      private
      def note_id
        params.permit[:id]
      end

      def note
        Note.find_by(note_id)
      end
    end
  end
end
