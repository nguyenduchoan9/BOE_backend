# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  rating     :float
#  desciption :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_feedbacks_on_user_id  (user_id)
#

class Feedback < ApplicationRecord
	belongs_to :user
end
