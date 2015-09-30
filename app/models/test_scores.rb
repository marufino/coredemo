class TestScores < ActiveRecord::Base
  belongs_to :project
  belongs_to :trainee
end
