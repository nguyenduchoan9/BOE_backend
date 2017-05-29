module Users
  class Serializer < BaseSerializer
    attributes :id, :full_name, :avatar, :phone, :provider, :role, :username, :membership

    def role
      object.role.try(:name)
    end

    def membership
    	object.membership.try(:level)
    end
  end
end
