%w(diner manager admin chef waiter).each do |name|
    Role.find_or_create_by!(name: name)
end

%w(primium silver gold diamond ruby).each do |level|
    mark_boundary, discount_rate = [5, 2] if level == 'primium'
    mark_boundary, discount_rate = [8, 4] if level == 'silver'
    mark_boundary, discount_rate = [10, 6] if level == 'gold'
    mark_boundary, discount_rate = [15, 8] if level == 'diamond'
    mark_boundary, discount_rate = [20, 10] if level == 'ruby'

    Membership.find_or_create_by!(level: level,
                                mark_boundary: mark_boundary,
                                discount_rate: discount_rate)
end


User.create(username: 'linhnk',
            password: '123123123',
            role: Role.find_by(name: 'dinner'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Nguyen Khanh Linh',
            membership: Membership.find_by(level: 'diamond'))
User.create(username: 'phongld',
            password: '123123123',
            role: Role.find_by(name: 'dinner'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Luu Duc Phong',
            membership: Membership.find_by(level: 'ruby'))
User.create(username: 'nampd',
            password: '123123123',
            role: Role.find_by(name: 'dinner'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Phan Dang Nam',
            membership: Membership.find_by(level: 'ruby'))
User.create(username: 'admin',
            password: '123123123',
            role: Role.find_by(name: 'admin'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Admin', membership: nil)
User.create(username: 'manager',
            password: '123123123',
            role: Role.find_by(name: 'manager'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Manger',
            membership: nil)
User.create(username: 'waiter',
            password: '123123123',
            role: Role.find_by(name: 'waiter'),
            avatar: '',
            phone: Faker::PhoneNumber.phone_number,
            full_name: 'Waiter',
            membership: nil)
Role.all.each { |r|
    membership = Membership.first if r.name.include?('diner')
    10.times do |i|
        User.create(username: r.name + i.to_s,
                    password: '123123123',
                    role: r,
                    full_name: Faker::Name,
                    membership: membership)
    end
}
