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

require 'rails_helper'

RSpec.describe Material, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
