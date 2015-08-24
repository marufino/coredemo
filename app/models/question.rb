class Question < ActiveRecord::Base

  belongs_to :survey_block
  has_one :rating

  validates :category, :presence => true
  validates :weight, :presence => true

end
