

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
end
