class PolicyUtils
  class << self
    def is_owner(user, record)
      user.id == record.user_id
    end

    # def is_admin?(user)
    #   user.role.try(:name) == 'admin'
    # end

    # def is_staff?(user)
    #   staff_has_store?(user) || admin_has_store?(user)
    # end

    # def is_manager?(user)
    #   user.role.try(:name) == 'manager'
    # end

    # def is_staff_owner?(user, store)
    #   is_staff?(user) && StaffStore.exists?(user: user, store: store)
    # end

    # def is_store_owner?(user, store)
    #   is_manager?(user) && user.id == store.manager_id
    # end

    # def admin_has_store?(user)
    #   user.role.try(:name) == 'manager' && Store.exists?(mananger_id: user.id)
    # end

    # def staff_has_store?(user)
    #   store_id = StaffStore.find_by(user_id: user.id).try(:store_id)
    #   user.role.try(:name) == 'staff' && Store.exists?(id: store_id)
    # end
  end
end
