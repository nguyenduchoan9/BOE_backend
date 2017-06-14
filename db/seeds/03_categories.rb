['Bún', 'Cá', 'Soup', 'Nướng', 'Nước'].each do |v|
    Category.find_or_create_by!(category_name: v)
end
