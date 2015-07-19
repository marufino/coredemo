class SurveyBlock < ActiveRecord::Base

  has_many :questions
  belongs_to :survey

  accepts_nested_attributes_for :questions

  validates :category, :presence => true
  validates :weight, :presence => true

end
