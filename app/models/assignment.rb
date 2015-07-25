class Assignment < ActiveRecord::Base

  has_and_belongs_to_many :trainees
  has_and_belongs_to_many :surveys

end
