class Trainee < ActiveRecord::Base

  has_and_belongs_to_many :assignments
  has_many :scores
  has_many :test_scores

  has_one :user, as: :meta

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
    if(totals.compact!=[])
      return mean(totals.compact).to_i
    else
      return 0
    end

  end

  def get_core_score_for_proj(project)
    scores = Score.where(:trainee_id => self.id)

    totals=[]
    scores.each do |s| if s.get_project == project then totals.push(s.total) end end
    if(totals.compact!=[])
      return mean(totals.compact).to_i
    else
      return 0
    end

  end

  def get_aos
    scores = Score.where(:trainee_id => self.id)

    competencies = []

    scores.each do |score|
      if score.completed
        score.area_of_strength.competencies.each do |c| competencies << c.name end
      end
    end

    counts = Hash.new 0

    competencies.each do |c|
      counts[c] += 1
    end
    counts = counts.sort_by{|k,v| v}.reverse
    return counts.first(3)
  end

  def get_aow
    scores = Score.where(:trainee_id => self.id)

    competencies = []

    scores.each do |score|
      if score.completed
        score.area_of_weakness.competencies.each do |c| competencies << c.name end
      end
    end

    counts = Hash.new 0

    competencies.each do |c|
      counts[c] += 1
    end
    counts = counts.sort_by{|k,v| v}.reverse
    return counts.first(3)
  end

  def mean(arr)
    arr.inject{ |sum, el| sum + el }.to_f / arr.size
  end

  def need_for_eval
    if self.next_scorecard
      date = self.next_scorecard.assigned_date
      return (Date.today() - date).to_i
    else
      return 1
    end
  end

  def need_for_eval_project(project)
    if self.next_scorecard_project(project)
      date = self.next_scorecard_project(project).assigned_date
      return (Date.today() - date).to_i
    else
      return 1
    end
  end

  def delete_all_scores

    scores = Score.where(:trainee_id => self.id)

    scores.each do |s|
      s.destroy
    end
  end

  def next_scorecard
    return Score.where(:completed => false).where(:trainee_id => self.id).order('assigned_date').first
  end

  def next_scorecard_project(project)

    assignments = project.assignments
    scores = []
    assignments.each do |a|
      a.scores.each do |s|
        if s.completed == false and s.trainee == self
          scores << s
        end
      end
    end
    scores.sort_by {|s| s.assigned_date}

    return scores.first

  end

  def last_scorecard_project(project)

    assignments = project.assignments
    scores = []
    assignments.each do |a|
      a.scores.each do |s|
        if s.trainee == self
          scores << s
        end
      end
    end
    scores.sort_by {|s| s.assigned_date}

    return scores.last

  end

  def last_completed_scorecard
    return Score.where(:completed => true).where(:trainee_id => self.id).order('completed_date').last
  end

  def previous_scorecard(score)
    n_s = Score.where(:trainee_id => self.id).where("completed_date < ?", score.completed_date).order('completed_date').last
    if (n_s)
      return n_s
    else
      return score
    end
  end

  def percent_scores_completed
    scores = Score.where(:trainee_id => self.id)
    completed = Score.where(:completed => 't').where(:trainee_id => self.id)

    return (completed.size  / scores.size.to_f) * 100
  end


end
