module Support
  module Authen
    def authenticate!
      if require_authen! && user == nil
        raise Unauthorized
      end
    end

    def require_authen!
    	self.class.require_authen ||= false
    end
  end
end
