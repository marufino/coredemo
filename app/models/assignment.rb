class Assignment < ActiveRecord::Base

  belongs_to :project
  has_and_belongs_to_many :trainees
  has_and_belongs_to_many :surveys
  has_many :scores, dependent: :destroy

  validates :date, presence: true
  validates :surveys, presence: true
  validates :trainees, presence: true

end
