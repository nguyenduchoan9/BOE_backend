

module ApplicationHelper
    require 'gcm'
    def send_message title, body, reg_tokens
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")

        registration_ids= reg_tokens

        options = {
            :registration_ids => [reg_tokens],
            :data => {
                :message => "Portugal"
            }
        }

        response = gcm.send(registration_ids, options)
        message = "hell"
        print response
    end

    def send_message_to_waiter body, reg_tokens
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new(Constant::SERVER_CHEF_GCM_KEY)

        options = {
            :registration_ids => [reg_tokens],
            :data => body
        }

        response = gcm.send(reg_tokensd, options)
    end

    def send_message_to_chef body, reg_tokens
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")

        registration_ids= reg_tokens

        response = gcm.send(registration_ids, options)
    end

    def send_message_to_diner body, reg_tokens
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new(Constant::SERVER_DINER_GCM_KEY)

        registration_ids= reg_tokens

        options = {
            :registration_ids => [reg_tokens],
            :data => {
                :message => "Portugal"
            }
        }

        response = gcm.send(registration_ids, options)
    end
end
