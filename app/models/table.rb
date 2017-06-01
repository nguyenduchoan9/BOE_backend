# == Schema Information
#
# Table name: tables
#
#  id           :integer          not null, primary key
#  table_number :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Table < ApplicationRecord

  def self.search(term)
    if term
      where('table_number = ?', "#{term.downcase}")
    else
      all
    end
  end
end
