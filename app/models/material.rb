# == Schema Information
#
# Table name: materials
#
#  id         :integer          not null, primary key
#  name       :string
#  available  :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Material < ApplicationRecord
	has_many :dishes
end
