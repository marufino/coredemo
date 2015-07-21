class Question < ActiveRecord::Base

  belongs_to :survey_block

  validates :category, :presence => true
  validates :weight, :presence => true

end
