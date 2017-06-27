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
#  status        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DiscountDay < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :dish_discounts
  has_many :dishes, through: :dish_discounts

  def self.search(term)
    if !term.nil? and term != ''
      where('lower(name) LIKE ? AND (discount_days.from_day >= current_date OR (discount_days.to_day >= current_date AND discount_days.from_day <= current_date))', "%#{term}%");
    end
  end
end
