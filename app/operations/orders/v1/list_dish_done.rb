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
                byebug
                split_list_done.each {|dish_done|
                    dish_done_detail = dish_done.split("_")
                    order_detail_var = order_detail(dish_done_detail[0], dish_done_detail[1])
                    quantity_not_serve = order_detail_var.quantity_not_serve
                    if order_detail_var.cooking_status == 0
                        if quantity_not_serve == 1
                            order_detail_var.update(quantity_not_serve: quantity_not_serve - 1, cooking_status: 1)
                        else
                            order_detail_var.update(quantity_not_serve: quantity_not_serve - 1)
                        end

                        NotificationWorker.perform_async(Constant::WAITER, order_detail_var.id, user.id, 0)
                    end
                }
            end

            def order_detail order_id, dish_id
                Order.find(order_id).order_details.find_by(:dish_id => dish_id)
            end

            # def order_detail_id
            #     @order_detail.id
            # end

        end
    end
end
