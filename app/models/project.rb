class Project < ActiveRecord::Base

  has_many :assignments
  has_and_belongs_to_many :observers
  has_many :surveys, through: :assignments
  has_many :trainees, through: :assignments

  accepts_nested_attributes_for :assignments
  accepts_nested_attributes_for :trainees

end

