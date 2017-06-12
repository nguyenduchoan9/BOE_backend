# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'properties' do
  	it { is_expected.to validate_presence_of(:name) }
  	it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_inclusion_of(:name).in_array(%w(user admin staff)) }
  end
end
