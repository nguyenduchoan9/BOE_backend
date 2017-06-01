module Users
    module V1
        class Create < Operation
            def process
                email = 'user' + User.all.count.to_s + '@gmail.com'
                user = User.new(user_params.merge(email: email))
                user.role_id = role.id
                raise ValidateError.new(user.errors) unless user.save
                result.new(
                    Users::Serializer.new(user),
                    user.create_new_auth_token
                )
            end

            private
            def role
                Role.find_by(:name => 'diner')
            end

            def user_params
                params.permit(
                    :full_name,
                    :username,
                    :password,
                    :password_confirmation
                )
            end

            def result
                Struct.new(:body, :header)
            end
        end
    end
end
