class Score < ActiveRecord::Base

  has_many :ratings
  belongs_to :trainee
  belongs_to :assignment

  accepts_nested_attributes_for :ratings

end
