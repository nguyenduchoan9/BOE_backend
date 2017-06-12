module Notes
    class Serializer < BaseSerializer
        cache key: 'Notes', expires_in: 1.hours

        attributes :id, :title, :body, :created_at, :updated_at, :status

        belongs_to :user

        def created_at
            DateUtils.format_date(object.created_at)
        end

        def updated_at
            DateUtils.format_date(object.updated_at)
        end
    end
end
