module PriceChangeHistories
    class Serializer < BaseSerializer
        cache key: 'PriceChangeHistories', expires_in: 1.hours


        attributes :id, :price, :from_date

        def price
            object.price.to_f
        end
    end
end
