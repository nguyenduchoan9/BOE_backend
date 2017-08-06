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

require 'rails_helper'

RSpec.describe Feedback, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
