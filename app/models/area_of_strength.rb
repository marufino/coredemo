class AreaOfStrength < ActiveRecord::Base
  has_and_belongs_to_many :competencies
  belongs_to :score
end
