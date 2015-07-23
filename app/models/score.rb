class Score < ActiveRecord::Base

  has_many :ratings
  belongs_to :trainee

  accepts_nested_attributes_for :ratings

end
