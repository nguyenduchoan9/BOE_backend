Category.all.each do |i|
    20.times do
        Dish.create(description: Faker::Lorem.paragraph(2),
                    dish_name: Faker::Food.spice,
                    image: '',
                    category_id: i)
    end
end
