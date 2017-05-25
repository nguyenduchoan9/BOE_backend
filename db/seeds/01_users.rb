%w(user staff manager admin).each do |name|
  Role.find_or_create_by!(name: name)
end

User.create(email: 'nguyendhoan@gmail.com', password: '123123123', role: Role.first, first_name: 'Hoang Nguyen')
User.create(email: 'barney@gmail.com', password: '123123123', role: Role.first, first_name: 'Nguyen Minh Khoi')
User.create(email: 'lehuyen@gmail.com', password: '123123123', role: Role.first, first_name: 'Nguyen Ba Le Huyen')
User.create(email: 'mobile@gmail.com', password: '123123123', role: Role.second, first_name: 'Mobile')
User.create(email: 'admin@gmail.com', password: '123123123', role: Role.find_by(name: 'admin'), first_name: 'Admin')
# manager = User.create(email: 'manager@gmail.com', password: '123123123', role: Role.find_by(name: 'manager'), first_name: 'Manager')

