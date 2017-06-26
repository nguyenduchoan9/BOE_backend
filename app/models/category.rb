# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  category_name :string
#  status        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Category < ApplicationRecord
	has_many :dishes

	def self.search(term)
		if term
			where('lower(category_name) LIKE ?', "%#{term.downcase}%")
		end
	end
end
