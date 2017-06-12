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

require 'rails_helper'

RSpec.describe DiscountDaysController, type: :controller do

end
