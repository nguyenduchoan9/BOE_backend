module Support
    module CheckDishAvailable
        def is_dish_available id
            Dish.find(id).material.available
        end
    end
end
