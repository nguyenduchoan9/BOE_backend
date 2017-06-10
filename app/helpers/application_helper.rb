

module ApplicationHelper
    require 'gcm'
    def send_message reg_tokens
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")

        registration_ids= reg_tokens
        options = {
            :registration_ids => [reg_tokens],
            :data => {
                :to => "diner",
                :body => "Phong stupid"
            }
        }

        response = gcm.send(registration_ids, options)
    end

    def send_message_to_waiter body, reg_tokens
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new(Constant::SERVER_CHEF_GCM_KEY)

        byebug
        options = {
            :registration_ids => [reg_tokens],
            :data => {
                :to => "waiter",
                :body => body
            }
        }
        response = gcm.send(reg_tokens, options)
        print response + '-------------------------'
    end

    def send_message_to_chef body, reg_tokens, term
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new(Constant::SERVER_CHEF_GCM_KEY)

        options = {
            :registration_ids => [reg_tokens],
            :data => {
                :to => "chef",
                :term => term,
                :body => body
            }
        }

        response = gcm.send(reg_tokens, options)
        print response + '-------------------------'
    end

    def send_message_to_diner body, reg_tokens
        # gcm = GCM.new("AIzaSyAhwjJ1Khh5T-uARG8WHAELj6y_xGMlpTs")
        gcm = GCM.new(Constant::SERVER_DINER_GCM_KEY)

        options = {
            :registration_ids => [reg_tokens],
            :data => {
                :to => "diner",
                :body => body
            }
        }

        response = gcm.send(reg_tokens, options)
        print response + '-------------------------'
    end
end
