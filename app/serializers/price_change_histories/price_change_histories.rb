module PriceChangeHistories
    class Serializer < BaseSerializer
        attributes :id, :price, :from_date
        
        def price
            object.price.to_f
        end
    end
end
