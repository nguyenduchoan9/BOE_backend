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

class Membership < ApplicationRecord
  validates :level, inclusion: {in: %w(primium silver gold diamond ruby)}
  validates :level, uniqueness: true
  validates :level, :mark_boundary, :discount_rate, presence: true

  has_many :users

  def self.search(term)
    if !term.nil?
      where('lower(level) LIKE ?', "%#{term.downcase}%")
    else
      all
    end
  end

end
