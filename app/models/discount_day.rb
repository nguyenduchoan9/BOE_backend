# == Schema Information
#
# Table name: discount_days
#
#  id            :integer          not null, primary key
#  from_day      :date
#  to_day        :date
#  discount_item :text
#  name          :string
#  image         :string
#  discount_rate :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DiscountDay < ApplicationRecord
end
