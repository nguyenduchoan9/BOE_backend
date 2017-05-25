module Support
  module Policy
    def policy
      if self.class.to_s.include?('Admins')
        "Admins::#{modules.first}Policy".constantize
      else
        "#{modules.first}Policy".constantize
      end
    end

    def authorize!(record, error = PermissionDenied)
      raise error unless policy.send(action + '_record', user, record)
    end

    def authorize_action!(error = PermissionDenied)
      if user && require_authorize
        raise error unless policy.send(action + '?', user)
      end
    end

    def require_authorize
      self.class.require_authorize ||= false
    end

    def action
      self.class.to_s.underscore.split('/').last
    end

    def modules
      self.class.to_s.split('::')
    end
  end
end