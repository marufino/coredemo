class Project < ActiveRecord::Base

  has_many :assignments
  has_and_belongs_to_many :observers
  has_many :surveys, through: :assignments
  has_many :trainees, through: :assignments

  accepts_nested_attributes_for :assignments
  accepts_nested_attributes_for :trainees

  def self.options_for_select
    order('id').map { |e| [e.name, e.id] }
  end

end

