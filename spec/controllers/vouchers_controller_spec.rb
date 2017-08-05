# == Schema Information
#
# Table name: vouchers
#
#  id         :integer          not null, primary key
#  total      :decimal(, )      default(0.0)
#  code       :string
#  status     :boolean          default(TRUE)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_vouchers_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe VouchersController, type: :controller do

end
