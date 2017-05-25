# == Schema Information
#
# Table name: tables
#
#  id           :integer          not null, primary key
#  table_number :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Table < ApplicationRecord
end
