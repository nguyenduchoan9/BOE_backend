module Orders
    module V1
        class NotifyOrderDetailNotAvailable < Operation
            require_authen!

            def process
                notify_webapp
                {status: true}
            end

            private

            def order_details_id_params
                params[:list_order_detail_id]
                # 1_@_@_@_@_
            end

            def notify_webapp
                list_orderdetail_id = order_details_id_params.split('_').uniq
                # list_orderdetail_id.uniq.each do |order_detail_id|
                #     orderdetail = OrderDetail.find order_detail_id
                #     fire_base.push("rejectedOrder", {status: 'new',
                #                                      dishName: "#{orderdetail.dish.dish_name}",
                #                                      date: "#{orderdetail.created_at.strftime('%d/%m/%Y')}"})
                # end
                handle_notify_to_user list_orderdetail_id
                handle_refund list_orderdetail_id
            end

            def handle_refund ids
                # order detail ids
                ids.uniq.each do |id|
                    order_detail = OrderDetail.find id
                    if order_detail.order.payment_method == 0
                        HardWorker.perform_async(ids, Constant::PAYPAL_METHOD)
                    else
                        refund_via_balance id
                    end
                end
            end

            def handle_notify_to_user order_detail_ids
                next_handle_ids = []
                if order_detail_ids
                    if order_detail_ids.count > 0
                        current_user_id = nil
                        od_id_group_by_user = []
                        order_detail_ids.each do |od_id|
                            order_detail_p = OrderDetail.find od_id
                            unless current_user_id
                                current_user_id = order_detail_p.order.user.id
                                od_id_group_by_user << od_id
                            else
                                process_user_id = order_detail_p.order.user.id
                                if process_user_id == current_user_id
                                    od_id_group_by_user << od_id
                                else
                                    next_handle_ids << od_id
                                end
                            end
                        end
                        # byebug
                        if current_user_id && od_id_group_by_user.count > 0
                            # update_total od_id_group_by_user
                            notify_to_user current_user_id, od_id_group_by_user
                        end

                        if next_handle_ids.count > 0
                            handle_notify_to_user next_handle_ids
                        end
                    end
                end
            end

            def update_total order_details_ids
                minus_total = 0
                order_details_ids.each do |od_id|
                    od = OrderDetail.find od_id
                    minus_total += (od.quantity_not_serve * od.price)
                end
                # byebug
                begin
                    ActiveRecord::Base.transaction do
                        order = OrderDetail.find(@id.first).order
                        order.update(total: order.total - minus_total)
                    end
                rescue StandardError => error
                    puts "Error - list_dish_notify"
                end
            end

            def notify_to_user user_id, order_details_ids
                NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 0, 0)
            end

            def notify_contruct
                Struct.new(:tableNumber, :status, :dishName, :price, :quantity, :order_detail_id)
            end

            def refund_via_balance(order_detail_id)
                # byebug
                order_detail = OrderDetail.find order_detail_id
                total = order_detail.price * order_detail.quantity_not_serve
                order_detail.order.user.balance += total
                order_detail.order.user.save!
                order_detail.cooking_status = 4
                order_detail.save!
                allowance = Allowance.new
                allowance.order_id = order_detail.order.id
                allowance.total = total
                allowance.save!
                order_detail.order.total -= total
                order_detail.order.save!
                user_id = order_detail.order.user_id
                notify_to_user_a user_id, order_detail_id.to_i, total
            end

            def notify_to_user_a user_id, order_details_ids, total_refund
                NotificationWorker.perform_async(Constant::DINER, order_details_ids, user_id, 2, total_refund)
            end
        end
    end
end
