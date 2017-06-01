Category.all.each do |i|
    images = ['0d5a8e5a3d3cf9c72e92e779c54fc0fe.jpg', '1.jpg', '9a4b4807cb30bb9f2607c202b7c0bdef.jpg', '13568_large.jpg', '160823141245-japan-food6-hiroshima-ramen-hiroshima-prefecturejnto-super-169.jpg',
            'bbh-31.jpg', 'bo-nuong-vietnam-food-stylist.jpg', 'breakfast_egg.jpg', 'breakfast_fibre.jpg', 'breakfast-vietnam-food-stylist-1280.jpg',
            'buncha-vietnamese-food.jpg', 'che-vietnamese.jpg', 'grill_prawn_food_vietnam_t.jpg', 'j1.jpg', 'japanesefood.jpg',
            'japanese-food-takoyaki-octopus-balls-japan-600.png', 'japan-food-lifestyle-culture_2fec2ff8-024e-11e7-b1f1-d4c6cd13dfb1.jpg',
            'lau-trai-ban-vietnam-food-stylist-960.jpg', 'maxresdefault.jpg', 'prawnbuncha_large.jpg', 'original.jpg', 'pho_bo.jpg',
            'vietnam-food-pho-bo1.jpg', 'what-to-eat-in-vietnam.jpg']
    20.times do
        image_url = '/images/' + images.shuffle.first.to_s
        Dish.find_or_create_by!(description: Faker::Lorem.paragraph(2),
                                dish_name: Faker::Food.spice,
                                image: image_url,
                                category: i)
    end
end
Dish.all.each do |dish|
    10.times do
        PriceChangeHistory.create(dish: dish, price: 100 + Random.rand(100), from_date: DateTime.now)
    end
end


# dish_id    :integer
#  price      :decimal(20, 2)
#  from_date  :datetime
