class Project < ActiveRecord::Base

  has_many :assignments, dependent: :destroy
  has_and_belongs_to_many :observers
  has_many :surveys, through: :assignments
  has_many :trainees, through: :assignments
  has_many :colors, dependent: :destroy



  accepts_nested_attributes_for :colors
  accepts_nested_attributes_for :assignments, allow_destroy: true
  accepts_nested_attributes_for :trainees


  validates_associated :assignments
  validates :observers, presence: true
  validates_associated :colors
  validates :name, presence: true




  def self.options_for_select
    order('id').map { |e| [e.name, e.id] }
  end

end

