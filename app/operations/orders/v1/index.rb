module Orders
    module V1
        class Index < Operation

            require_authen!
            def process
                result
            end

            private
            def get_order
                user.orders.order(created_at: :desc)
            end

            def result
                rs = []
                group_order_in_two_hour.each do |group_order|
                    total = 0;
                    list_id_order = ''
                    created_at = nil
                    group_order.each do |order|
                        created_at = order.create_at if created_at == nil
                        list_id_order = order.id.to_s if list_id_order.length == 0
                        list_id_order += '_' + order.id.to_s unless list_id_order.length == 0
                        total += order.total
                    end
                    rs << result_construct.new(total, DateUtils.format_date(created_at), list_id_order)
                end
                rs
            end

            def result_construct
                Struct.new(:total, :create_at, :list_order_id)
            end



            def group_order_in_two_hour
                grouped_order = []
                group_item = []
                get_order.each do |order|
                    if group_item.size == 0
                        group_item << order
                    else
                        if group_item.last.created_at.to_i - order.created_at.to_i < 2.hour.to_i
                            group_item << order
                        else
                            grouped_order << group_item
                            group_item = []
                        end
                    end
                end
                grouped_order
            end
        end
    end
end
