class SurveyBlock < ActiveRecord::Base
  has_many :questions, inverse_of: :survey_block
end
