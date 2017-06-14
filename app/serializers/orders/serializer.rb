module Orders
    class Serializer < BaseSerializer
        cache key: 'Orders', expires_in: 1.hours

        attributes :id, :total, :order_date

        def order_date
            DateUtils.format_date(object.created_at)
        end

    end
end

# total                       :decimal(20, 2)
#  discount_date_by_membership :string
#  user_id                     :integer
#  table_number                :integer
#  status                      :boolean
#  created_at
