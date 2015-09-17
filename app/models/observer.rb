class Observer < ActiveRecord::Base

  has_and_belongs_to_many :projects

  has_one :user, as: :meta, dependent: :destroy

  accepts_nested_attributes_for :user

  def self.options_for_select
    order('id').map { |e| [e.user.full_name, e.id] }
  end

  def previous_scorecard(score)
    proj = self.projects
    ass = []
    proj.each do |p|
      ass << p.assignments.ids
    end

    n_s = Score.where(:assignment_id => ass).where("completed_date < ?", score.completed_date).order('completed_date').last
    if (n_s)
      return n_s
    else
      return score
    end
  end

  def due_scorecard
    proj = self.projects
    ass = []
    proj.each do |p|
      ass << p.assignments.ids
    end

    n_s = Score.where(:assignment_id => ass).where(:completed => false).order('assigned_date').first
    if (n_s)
      return n_s
    else
      return score
    end
  end



end
