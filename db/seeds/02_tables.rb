15.times do |v|
    Table.find_or_create_by!(table_number: v)
end
