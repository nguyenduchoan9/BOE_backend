module Dishes
    class Serializer < BaseSerializer
        attributes :id, :description, :dish_name, :image, :price

        # has_many :price_change_histories, serializer: PriceChangeHistories::Serializer
        # # def price
        # #     object.price_change_histories.try(:price)
        # # end
        def price
            Dish.find(object.id).price_change_histories.last.try(:price)
        end
    end
end
