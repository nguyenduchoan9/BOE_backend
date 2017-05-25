module Sessions
  class Base < Operation

    def process
      user = find_user
      unless provider == 'email'
        user = update_user(user)
        user.save
      end
      result.new(
          Users::Serializer.new(user),
          user.create_new_auth_token
        )
    end

    private
    def find_user
      User.where(:uid => uid, :provider => provider).first_or_initialize
    end

    def update_user(user)
      user.last_sign_in = Time.now
      user.password = User.friendly_token.first(20)
      user
    end

    def uid
      raise NotImplementedError
    end

    def provider
      raise NotImplementedError
    end

    def result
      Struct.new(:body, :header)
    end
  end
end
