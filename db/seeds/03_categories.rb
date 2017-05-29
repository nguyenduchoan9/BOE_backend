['Appertize', 'Desert', 'Main Course', 'First Course', 'Side Dish', 'Vegetarian', 'Cheap', 'Pizza', 'Drinking'].each do |v|
    Category.find_or_create_by!(category_name: v)
end
