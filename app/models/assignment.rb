class Assignment < ActiveRecord::Base

  has_and_belongs_to_many :trainees
  has_and_belongs_to_many :surveys
  has_many :scores, dependent: :destroy

  validates_associated :surveys
  validates_associated :trainees

end
