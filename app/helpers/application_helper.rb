module ApplicationHelper

  def get_scores_by_observer(obs)
    scores = []
    obs.projects.each {|proj| proj.assignments.order(:date).each {|ass| Score.where(:assignment_id => ass.id).each {|score| scores << score} }}
    return scores
  end

  def get_trainees_by_observer(obs)
    trainees = []
    obs.projects.each {|proj| proj.assignments.order(:date).each {|ass| ass.trainees.each{|t| trainees << t} }}
    return trainees.uniq
  end

  def graph_scores_for_trainee(trainee)
    graph = [[]]
    knowledge = []
    skills = []
    abilities = []
    totals = []
    dates = []
    # scores for current user
    scores = Score.where( :trainee_id => trainee.id)
    # parse out totals
    scores.each { |s| knowledge << s.knowledge}
    scores.each { |s| skills << s.skills}
    scores.each { |s| abilities << s.abilities}
    scores.each { |s| totals << s.total}
    # parse out dates
    scores.each { |s| dates << s.assignment.date}
    graph[0] = dates.zip totals
    graph[1] = dates.zip knowledge
    graph[2] = dates.zip skills
    graph[3] = dates.zip abilities
    return graph
  end

  def compute_percent_improvement(second, first, trainee)

    second_score  = Score.find_by(:assignment_id => second.id, :trainee_id => trainee.id)
    first_score   = Score.find_by(:assignment_id => first.id, :trainee_id => trainee.id)

    percent_improvement = Hash.new
    percent_improvement['knowledge'] = ((second_score.knowledge - first_score.knowledge) / first_score.knowledge) * 100
    percent_improvement['skills'] = (second_score.skills - first_score.skills) / first_score.skills
    percent_improvement['abilities'] = (second_score.abilities - first_score.abilities) / first_score.abilities
    percent_improvement['total'] = (second_score.total - first_score.total) / first_score.total

    return percent_improvement

  end


end
