%w(diner manager admin chef waiter cashier).each do |name|
    Role.find_or_create_by!(name: name)
end

User.create(username: 'phongluuduc1',
            password: '123123123',
            email: 'phong@gmail.com',
            role: Role.find_by(name: 'diner'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Luu Duc Phong')

User.create(username: 'khanhlinh',
            password: '123123123',
            email: 'linhnk@gmail.com',
            role: Role.find_by(name: 'diner'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Nguyen Khanh Linh')

User.create(username: 'namphandang',
            password: '123123123',
            email: 'namdp@gmail.com',
            role: Role.find_by(name: 'diner'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Phan Dang Nam')

User.create(username: 'hoangnguyen',
            password: '12345678',
            email: 'hoangnd@gmail.com',
            role: Role.find_by(name: 'diner'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Nguyen Duc Hoang')

User.create(username: 'adminadmin',
            password: '123123123',
            email: 'admin@gmail.com',
            role: Role.find_by(name: 'admin'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Admin')
User.create(username: 'managermanager',
            password: '123123123',
            email: 'manager@gmail.com',
            role: Role.find_by(name: 'manager'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Manger')
User.create(username: 'masterwaiter',
            password: '12345678',
            email: 'masterwaiter@gmail.com',
            role: Role.find_by(name: 'waiter'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Waiter')
User.create(username: 'masterchef',
            password: '12345678',
            email: 'masterchef@gmail.com',
            role: Role.find_by(name: 'chef'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Chef')
User.create(username: 'mastercashier',
            password: '12345678',
            email: 'mastercashier@gmail.com',
            role: Role.find_by(name: 'cashier'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Cashier')

# Role.all.each { |r|
#     membership = Membership.first if r.name.include?('diner')
#     10.times do |i|
#         User.create(username: r.name + i.to_s,
#                     password: '123123123',
#                     email: r.name + i.to_s + '@gmail.com',
#                     role: r,
#                     full_name: Faker::Name.name,
#                     membership: membership)
#     end
# }
