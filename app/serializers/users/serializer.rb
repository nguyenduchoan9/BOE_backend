module Users
  class Serializer < BaseSerializer
    attributes :id, :first_name, :avatar, :phone, :address, :email, :role, :last_name, :provider, :uid

    def role
      object.role.try(:name)
    end
  end
end
