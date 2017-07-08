module Orders
    module V1
        class TableDish < Operation

            def process
                @table = []
                select_by_hoang
            end

            private
            def get_recent_order
                @order ||= Order.where('created_at < ? AND created_at > ?',Time.now, Time.now - 1.day).order(created_at: :desc)
            end

            def select_by_hoang
                table_with_dish = []
                get_recent_order.each do |od|
                    unless is_exist_in_table od.table_number

                        dishes_list = []
                        od.order_details.each do |odetail|
                            if odetail.cooking_status == 0
                                # byebug
                                dishes_list << Dishes::Serializer.new(Dish.find(odetail.dish_id))
                            end
                        end
                        # byebug
                        if dishes_list.count > 0
                              # byebug
                            @table << od.table_number
                            table_with_dish << result.new(od.table_number, dishes_list)
                        end
                    end
                end
                # byebug
                table_with_dish
            end

            def is_exist_in_table table_number
                @table.include? table_number
            end

            def result
                Struct.new(:table_number, :dishes)
            end
        end
    end
end
