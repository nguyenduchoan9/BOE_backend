Category.all.each do |i|
	20.times do
		Dish.create(description: '', dish_name: '', image: '', category_id: i)
	end
end