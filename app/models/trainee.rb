class Trainee < ActiveRecord::Base

  has_and_belongs_to_many :assignments
  has_and_belongs_to_many :scores

  has_one :user, as: :meta, dependent: :destroy

  accepts_nested_attributes_for :user

  def get_nth_assignment(n)
    return self.assignments.order('date')[n]
  end

  def self.options_for_select
    order('id').map { |e| [e.user.full_name, e.id] }
  end

  def get_core_score
    scores = Score.where(:trainee_id => self.id)
    totals=[]
    scores.each do |s| totals.push(s.total) end
    return mean(totals).to_i
  end

  def mean(arr)
    arr.inject{ |sum, el| sum + el }.to_f / arr.size
  end

  def need_for_eval
    scores = Score.where(:trainee_id => self.id).where(:completed => )
  end

  def next_scorecard
    return Score.where
  end

end
