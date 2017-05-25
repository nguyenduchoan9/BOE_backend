# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  title      :string
#  body       :text
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notes_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "association" do
    it { should belong_to(:user) }
  end
end
