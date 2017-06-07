module Users
    class Serializer < BaseSerializer
        cache key: 'Users', expires_in: 1.hours
        
        attributes :id, :full_name, :avatar, :phone, :provider, :role, :username, :membership

        def role
            object.role.try(:name)
        end

        def membership
            object.membership.try(:level)
        end
    end
end
