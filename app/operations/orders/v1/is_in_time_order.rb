module Orders
    module V1
        class IsInTimeOrder < Operation
            include ConfigBoeHelper

            def process
                is_available
            end

            private
            def get_time_res_close
                @time_close ||= get_time_close
            end

            def hour_close
                @hour_close ||= get_time_res_close[:hour]
            end

            def minute_close
                @minute_close ||= get_time_res_close[:min]
            end

            def time_now
                @time_now = Time.now
            end

            def hour_now
                @hour_now ||= time_now.hour
            end

            def minute_now
                @minute_now ||= time_now.min
            end

            def is_available
                # byebug
                if hour_now < hour_close
                    return result_struct.new(true)
                elsif  hour_now == hour_close && minute_now < minute_close
                    return result_struct.new(true)
                else
                    return result_struct.new(false)
                end
            end

            def result_struct
                Struct.new(:is_available)
            end
        end
    end
end
