module Sessions
    module V1
        class Destroy < Operation
            require_authen!

            def process
                client_id = headers['client']
                user.tokens.delete(client_id)
                user.reg_token = ''
                user.save!
                {success: true}
            end
        end
    end
end
