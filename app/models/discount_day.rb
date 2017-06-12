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

  def self.search(term)
    if !term.nil? and term != ''
      where('from_day <= ? AND ? <= to_day', "%#{term.to_date}%", "%#{term.to_date}%")
    else
      all
    end
  end
end
