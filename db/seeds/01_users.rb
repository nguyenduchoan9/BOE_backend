%w(diner manager admin chef waiter).each do |name|
    Role.find_or_create_by!(name: name)
end

%w(primium silver gold diamond ruby).each do |level|
    mark_boundary, discount_rate = [5, 2] if level == 'primium'
    mark_boundary, discount_rate = [8, 4] if level == 'silver'
    mark_boundary, discount_rate = [10, 6] if level == 'gold'
    mark_boundary, discount_rate = [15, 8] if level == 'diamond'
    mark_boundary, discount_rate = [20, 10] if level == 'ruby'
    Membership.find_or_create_by!(level: level, mark_boundary: mark_boundary, discount_rate: discount_rate)
end


User.create(username: 'linhnk', password: '123123123', role: Role.find_by(name: 'diner'), full_name: 'Nguyen Khanh Linh', membership: Membership.find_by(level: 'diamond'))
User.create(username: 'phongld', password: '123123123', role: Role.find_by(name: 'diner'), full_name: 'Luu Duc Phong', membership: Membership.find_by(level: 'ruby'))
User.create(username: 'nampd', password: '123123123', role: Role.find_by(name: 'diner'), full_name: 'Phan Dang Nam', membership: Membership.find_by(level: 'ruby'))
User.create(username: 'admin', password: '123123123', role: Role.find_by(name: 'admin'), full_name: 'Admin', membership: nil)
User.create(username: 'manager', password: '123123123', role: Role.find_by(name: 'manager'), full_name: 'Manger', membership: nil)
User.create(username: 'waiter', password: '123123123', role: Role.find_by(name: 'waiter'), full_name: 'Waiter', membership: nil)
