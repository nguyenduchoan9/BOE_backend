module Orders
    module V1
        class Create < Operation
            require_authen!

            def process
                do_transaction!
                s = check_dish_cart_avilable.size
                if s == 0
                    NotificationWorker.perform_async(Constant::CHEF, order.id, user.id, 1, 0)
                else
                end
                result.new(order.id, list_dish_reject)
            end

            private

            def order_params
                params[:order]
            end

            def table_number
                params[:table_number]
            end

            def payment_id
                params[:payment_id]
            end

            def description_params
                @description_params ||= params[:list]
            end

            def find_description_by_dish_id dish_id
                description_params.each do |item|
                    return item if item[:dishId] == dish_id.to_i
                end
                nil
            end

            def do_transaction!
                begin
                    ActiveRecord::Base.transaction do
                        OrderDetail.import(build_order_details)
                        order.update!(total: total, table_number: table_number, payment_id: payment_id)
                    end

                rescue StandardError => error
                    raise ValidateError.new(error)
                end
            end

            def list_cart_object
                cart_list = []
                dish = ''
                des = nil
                order_params.split('_').each_with_index do |item, index|
                    if index.even?
                        dish = Dish.find(item)
                        des = find_description_by_dish_id item
                    elsif index.odd?
                        cart_item = cart_object.new(dish, item, format_des(des))
                        cart_list << cart_item
                    end
                end
                cart_list
            end

            def format_des des
                rs = ''
                if des
                    des.fetch(:description).each do |s|
                        if s.length == 0
                            rs = rs + Constant::BLANK_CHARATER + Constant::SEPARATE_CHARATER_DES
                        else
                            rs = rs + s + Constant::SEPARATE_CHARATER_DES
                        end
                    end
                end
                rs.first(-3)
            end

            def build_order_details
                list_cart_object.map do |cart|
                    order.order_details.new(
                        price: cart[:dish].price_change_histories.order(from_date: :asc).last.try(:price),
                        discount_rate_by_day: 0,
                        quantity: cart[:quantity],
                        dish_id: cart[:dish].id,
                        quantity_not_serve: cart[:quantity],
                        quantity_not_served: cart[:quantity],
                        description: cart[:des]
                    )
                end
            end

            def cart_object
                Struct.new(:dish, :quantity, :des)
            end

            def total
                order.order_details.reduce(0) do |result, order_details|
                    result + (order_details.price * order_details.quantity)
                end
            end

            def order
                @order ||= user.orders.create!

            end

            def check_dish_cart_avilable
                reject_dish = []
                list_cart_object.each do |cart|
                    reject_dish <<  cart[:dish].id unless is_dish_available cart[:dish].id
                end
                reject_dish
            end

            def list_dish_reject
                rs = []
                check_dish_cart_avilable.each do |ids|
                    rs << Dishes::Serializer.new(Dish.find(ids))
                end
                rs
            end

            def result
                Struct.new(:order_id, :dish)
            end
        end
    end
end

# ***** ORDER ***********
#-1: dish is cancel
# 0 : dish is cooking
# 1: cashing

# ***** ORDER DETAIL***********
#-1: reject
# 0: cooking
# 1: serving
# 2: finish
# 3: refunding
# 4: refunded

# ***** PAYMENT METHOD ******
# 0: PAYPAL
# 1: CASH
# 2: VOUCHER
