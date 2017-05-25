class NotesPolicy < GeneralPolicy
  class << self
    def update_record(user, record)
      PolicyUtils.is_owner(user, record)
    end

    def show_record(user, record)
      PolicyUtils.is_owner(user, record)
    end
  end
end
