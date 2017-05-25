module Helpers
  module Authen
    def sign_in(user)
      auth_headers = user.create_new_auth_token
      @request.headers.merge!(auth_headers)
      auth_headers
    end

    def sign_in_admin(admin)
      session[:admin_id] = admin.id
      session[:admin_token] = admin.token
    end

    def set_version(version = 'v1')
      @request.headers.merge!(AcceptVersion: "version=#{version}")
    end
  end
end
