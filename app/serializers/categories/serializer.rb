module Categories
    class Serializer < BaseSerializer
        cache key: 'Categoris', expires_in: 1.hours


        attributes :id, :category_name

        
    end
end
