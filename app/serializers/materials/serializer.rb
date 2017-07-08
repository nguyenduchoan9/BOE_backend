module Materials
    class Serializer < BaseSerializer
        cache key: 'Material', expires_in: 1.hours

        attributes :id, :name, :available

    end
end
