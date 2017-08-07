module Feedbacks
    module V1
        class Create < Operation
            require_authen!

            def process
                a = user.feedbacks.new
                a.rating = rate_params
                a.desciption = feed_back_params
                a.save
                {status: true}
            end

            private
            def rate_params
                params[:rate]
            end

            def feed_back_params
                params[:feed_back]
            end


        end
    end
end
