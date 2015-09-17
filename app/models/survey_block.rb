class SurveyBlock < ActiveRecord::Base

  has_many :questions, dependent: :destroy
  belongs_to :survey

  accepts_nested_attributes_for :questions, allow_destroy: true

end
