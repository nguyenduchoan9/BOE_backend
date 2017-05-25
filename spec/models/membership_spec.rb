# == Schema Information
#
# Table name: memberships
#
#  id            :integer          not null, primary key
#  mark_boundary :float
#  discount_rate :float
#  level         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Membership, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
