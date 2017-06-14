# 'Bún', 'Cá', 'Soup', 'Nướng', 'Nước'
Category.all.each do |i|
    bun_image = ['bun-bo.jpg', 'bun-bo-hue.jpg', 'bun_ca_loc.jpg', 'hu-tieu-ca-loc-kieu-trung.jpg' , 'hu-tieu-mi-du-ky.jpg', 'hu-tiu-nam-vang.jpg',
                 'mien-xao-tom-kieu-trung-quoc.jpg', 'mi-kishimen-nhat-ban.jpg', 'mi_lanh_somen_nhat ban.jpg', 'mi_ramen_nhat ban.jpg',
                 'mi_soba_nhat ban.jpg', 'mi-tron-tay-ban-nha.jpg', 'mi_udon_nhat_ban.jpg', 'pho.jpg']
    bun_name = ['Bún Bò', 'Bún Bò Huế', 'Bún Cá Lóc', 'Hủ tiếu cà lóc', 'Hủ tiếu mì du ký', 'Hủ tiếu nam vang', 'Miến xào tôm',
                'Mì kishimen Nhật Bản', 'Mì lạnh somen Nhật Bản', 'Mì ramen Nhật Bản', 'Mì soba Nhật Bản', 'Mì trộn Tây Ban Nha',
                'Mì Udon Nhật Bản', 'Phở']

    ca_image =['ca-hap-gung-kieu-trung.jpg', 'ca_hoi_nuong_ngu_vi.jpg', 'ca-nuong-bulgari.jpg', 'chao-ca-singapore.JPG',
             'cua_xao.jpg', 'sushi-ca-hoi.jpg']
    ca_name=['Cá hấp gừng kiểu Trung', 'Cá hồi nướng ngủ vị', 'Cá nướng Bulgari', 'Cháo cá Singapore', 'Cua xào', 'Shushi cá hồi']

    sup_image = ['Sup-Trai.jpg', 'sup-tom-thai.jpg', 'sup-muc-tuoi.jpg', 'sup-kimchi-dau-phu.jpg', 'sup-ngo.jpg']
    sup_name = ['Súp trai','Súp tôm thái', 'Súp mực tươi', 'Súc kimchi đậu phụ', 'Súp ngô']

    nuong_image = ['tom-uop-sua-chua-nuong.jpg', 'thit-nuong-texas.jpg', 'thit-nuong-indonesia.jpg', 'suon-cuu-nuong.JPG',
                 'hau-nuong-pho-mai-kieu-phap.jpg', 'ga_nuong_phomai_han_quoc.jpg', 'bo-nuong-beefstek-canada.jpg', 'ba-roi-xong-khoi-cuon-bo-bam.jpg']
    nuong_name = ['Tôm ướp sửexasua nướng', 'Thịt nướng Texas', 'Thịt nướng Indonesia', 'Sường cừu nướng', 'Hầu nướng phô mai kiều Pháp',
                'Gà nướng phô mai', 'Bò nướng Canada', 'Ba rọi xông khói']

    drink_image = ['bac-ha-thuong-hai.jpg', 'ruou-vang-chile.jpg', 'tra-quat-mat-ong.jpg', 'tra-buoi-mat-ong.jpg', 'tra-chanh-dai-tay-duong.jpg',
                 'tra-tao-do.jpg', 'tra-chanh-mat-ong-trung-dong.jpg', 'vang-barton-guestier.jpg']
    drink_name = ['Bạc hà Thượng Hải', 'Rượu vang Chile', 'Trà quất mất ong', 'Trà bưởi mật ong', 'Trà chang dây',
                'Trà táo đỏ', 'Trà chang mật ong Trung đông', 'Rượu vang Barton-guestier']

    if(i.id == 1)
        bun_name.each_with_index do |name, index|
            image_url = '/images/' + bun_image[index]
            Dish.find_or_create_by!(description: Faker::Lorem.paragraph(2),
                                    dish_name: bun_name[index],
                                    image: image_url,
                                    category: i)
        end
    end
    if(i.id == 2)
        ca_name.each_with_index do |name, index|
            image_url = '/images/' + ca_image[index]
            Dish.find_or_create_by!(description: Faker::Lorem.paragraph(2),
                                    dish_name: ca_name[index],
                                    image: image_url,
                                    category: i)
        end
    end
    if(i.id == 3)
        sup_name.each_with_index do |name, index|
            image_url = '/images/' + sup_image[index]
            Dish.find_or_create_by!(description: Faker::Lorem.paragraph(2),
                                    dish_name: sup_name[index],
                                    image: image_url,
                                    category: i)
        end
    end
    if(i.id == 4)
        nuong_name.each_with_index do |name, index|
            image_url = '/images/' + nuong_image[index]
            Dish.find_or_create_by!(description: Faker::Lorem.paragraph(2),
                                    dish_name: nuong_name[index],
                                    image: image_url,
                                    category: i)
        end
    end
    if(i.id == 5)
        drink_name.each_with_index do |name, index|
            image_url = '/images/' + drink_image[index]
            Dish.find_or_create_by!(description: Faker::Lorem.paragraph(2),
                                    dish_name: drink_name[index],
                                    image: image_url,
                                    category: i)
        end
    end
end

Dish.all.each do |dish|
    Random.rand(10).times do
        PriceChangeHistory.create(dish: dish, price: 50 + Random.rand(10)*10, from_date: DateTime.now)
    end
end


# dish_id    :integer
#  price      :decimal(20, 2)
#  from_date  :datetime
