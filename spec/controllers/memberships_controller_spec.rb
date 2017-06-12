# == Schema Information
#
# Table name: memberships
#
#  id            :integer          not null, primary key
#  mark_boundary :float
#  discount_rate :float
#  level         :string
#  status        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe MembershipsController, type: :controller do

end
