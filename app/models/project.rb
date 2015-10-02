class Project < ActiveRecord::Base

  has_many :assignments, dependent: :destroy
  has_and_belongs_to_many :observers
  has_many :surveys, through: :assignments
  has_many :trainees, through: :assignments
  has_many :colors, dependent: :destroy
  has_many :test_scores, dependent: :destroy


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

  def get_completed_scores
    scores = []
    self.assignments.order(:date).each {|ass| Score.where(:assignment_id => ass.id).each {|score| if score.completed then scores << score end} }
    return scores
  end

  def get_non_completed_scores
    scores = []
    self.assignments.order(:date).each {|ass| Score.where(:assignment_id => ass.id).each {|score| if !score.completed then scores << score end} }
    return scores
  end


end

