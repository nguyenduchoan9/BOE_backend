module Orders
    module V1
        class ListDishDone < Operation

            require_authen!

            def process
                send_each_notification
                { status: true }
            end

            private

            def list_done
                params[:list_done]
            end

            def split_list_done
                @list_from_check_box ||= list_done.split(";")
            end

            def send_each_notification
                split_list_done.each {|dish_done|
                    dish_done_detail = dish_done.split("-")
                    order_detail(dish_done_detail[0], dish_done_detail[1])
                    NotificationWorker.perform_async(Constant::WAITER, order_detail_id, user.id)
                    
                }
            end

            def order_detail order_id, dish_id
                @order_detail ||= Order.find(order_id).order_details.find_by(:dish_id => dish_id)
            end

            def order_detail_id
                order_detail.id
            end

        end
    end
end
