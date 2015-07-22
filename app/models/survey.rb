class Survey < ActiveRecord::Base

  has_many :survey_blocks
  has_many :questions , through: :survey_blocks

  accepts_nested_attributes_for :survey_blocks


end