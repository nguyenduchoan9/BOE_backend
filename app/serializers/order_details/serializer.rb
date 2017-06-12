module OrderDetails
    class Serializer < BaseSerializer
        cache key: 'OrderDetails', expires_in: 1.hours
        
        attributes :id, 

        def role
            object.role.try(:name)
        end

        def membership
            object.membership.try(:level)
        end
    end
end


 id                   :integer          not null, primary key
#  price                :decimal(20, 2)
#  discount_rate_by_day :float
#  quantity             :integer
#  order_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  dish_id 