# == Schema Information
#
# Table name: allowances
#
#  id    :integer          not null, primary key
#  total :decimal(, )
#

class Allowance < ApplicationRecord
	belongs_to :order
end
