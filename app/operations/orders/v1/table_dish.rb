module Orders
    module V1
        class TableDish < Operation
            include ConfigBoeHelper
            def process
                # @table = []
                @table_with_time = []
                select_by_hoang
            end

            private
            def get_recent_order
                @order ||= Order.where('created_at < ? AND created_at > ? AND cooking_status = 0',Time.now, Time.now - 1.day).order(created_at: :desc)
            end

            def select_by_hoang
                table_with_dish = []
                get_recent_order.each do |od|
                    pos = is_exist_in_table_in_time od.table_number
                    if  pos == -1
                        dishes_list = []
                        od.order_details.each do |odetail|
                            if odetail.cooking_status == 1 || odetail.cooking_status == 0
                                # byebug
                                if odetail.quantity > odetail.quantity_not_serve && (odetail.quantity_not_served - odetail.quantity_not_serve) > 0
                                    dishes_list << dish_detail_hash.new(Dishes::Serializer.new(Dish.find(odetail.dish_id)),
                                                                        odetail.id, odetail.quantity_not_served - odetail.quantity_not_serve)
                                end
                            end
                        end
                        # byebug
                        if dishes_list.count > 0
                            # byebug
                            @table_with_time << table_time_hash.new(od.table_number, od.created_at.to_i)
                            table_with_dish << result.new(od.table_number, dishes_list)
                        end
                    else
                        item_table_time = @table_with_time[pos]
                        item_table_dish = table_with_dish[pos]
                        current_od_time = od.created_at.to_i
                        if (item_table_time[:time_order] - current_od_time) < get_time_group_in_int
                            dishes_list = []
                            od.order_details.each do |odetail|
                                if odetail.cooking_status == 1 || odetail.cooking_status == 0
                                    # byebug
                                    if odetail.quantity > odetail.quantity_not_serve && (odetail.quantity_not_served - odetail.quantity_not_serve) > 0
                                        dishes_list << dish_detail_hash.new(Dishes::Serializer.new(Dish.find(odetail.dish_id)),
                                                                            odetail.id, odetail.quantity_not_served - odetail.quantity_not_serve)
                                    end
                                end
                            end
                            if dishes_list.count > 0
                                item_table_time[:time_order] = od.created_at.to_i
                                @table_with_time[pos] = item_table_time
                                current_list = item_table_dish[:dish_detail]
                                dishes_list.each do |item|
                                    current_list << item
                                end
                                item_table_dish.dish_detail = current_list
                                table_with_dish[pos] = item_table_dish
                            end
                        end
                    end
                end
                # byebug
                table_with_dish
            end

            def is_exist_in_table table_number
                @table.include? table_number
            end

            def is_exist_in_table_in_time table_number
                @table_with_time.each_with_index do |item, index|
                    return index if item[:table_number] == table_number
                end
                return -1
            end

            def result
                Struct.new(:table_number, :dish_detail)
            end

            def dish_detail_hash
                Struct.new(:dish, :order_detail_id, :quantity_not_serve)
            end

            def table_time_hash
                Struct.new(:table_number, :time_order)
            end

            def get_time_group_order
                @time_group ||= get_time_group
            end

            def get_time_group_in_int
                get_time_group_order[:hour].hour.to_i + get_time_group_order[:min].minutes.to_i
            end
        end
    end
end
