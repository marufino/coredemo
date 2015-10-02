module ApplicationHelper

  def get_scores_by_observer(obs)
    scores = []
    obs.projects.each {|proj| proj.assignments.order(:date).each {|ass| Score.where(:assignment_id => ass.id).each {|score| if score.completed then scores << score end} }}
    return scores
  end

  def get_non_completed_scores_by_observer(obs)
    scores = []
    obs.projects.each {|proj| proj.assignments.order(:date).each {|ass| Score.where(:assignment_id => ass.id).each {|score| if !score.completed then scores << score end} }}
    return scores
  end

  def get_trainees_by_observer(obs)
    trainees = []
    obs.projects.each {|proj| proj.assignments.order(:date).each {|ass| ass.trainees.each{|t| trainees << t} }}
    return trainees.uniq
  end


  def get_trainees_by_project(project)
    trainees = []
    project.assignments.order(:date).each {|ass| ass.trainees.each{|t| trainees << t} }
    return trainees.uniq
  end


  def create_graph_for_scores(scores)
    graph = [[]]
    knowledge = []
    skills = []
    abilities = []
    totals = []
    dates = []
    # parse out totals
    scores.each { |s| knowledge << s.knowledge}
    scores.each { |s| skills << s.skills}
    scores.each { |s| abilities << s.abilities}
    scores.each { |s| totals << s.total}
    # parse out dates
    scores.each { |s| dates << s.completed_date}
    graph[0] = dates.zip totals
    graph[1] = dates.zip knowledge
    graph[2] = dates.zip skills
    graph[3] = dates.zip abilities
    return graph
  end

  def graph_scores_for_trainee(trainee)

    # scores for trainee
    scores = Score.where( :trainee_id => trainee.id).where( :completed => 't')

    return create_graph_for_scores(scores)
  end

  def graph_scores_for_observer(observer)
    scores = get_scores_by_observer(observer)

    return create_graph_for_scores(average_scores_weekly(scores))
  end

  def graph_scores_for_project(project)
    scores = project.get_completed_scores

    return create_graph_for_scores(average_scores_weekly(scores))
  end

  def graph_scores_for_admin
    scores = Score.where(:completed => 't')
    return create_graph_for_scores(average_scores_weekly(scores))
  end

  def average_scores_weekly(scores)
    # group scores by week
    grouped_scores = scores.group_by{ |u| u.completed_date.beginning_of_week }

    avg_scores=[]
    grouped_scores.each do |group|
      average = Score.new
      total_knowledge = 0
      total_skills = 0
      total_abilities = 0
      total_totals = 0

      group[1].each do |score|
        #compute total scores for everyone
        total_knowledge = total_knowledge + score.knowledge
        total_skills = total_skills + score.skills
        total_abilities = total_abilities + score.abilities
        total_totals = total_totals + score.total
      end

      # calculate average for the week
      average.knowledge = total_knowledge / group[1].size
      average.skills = total_skills / group[1].size
      average.abilities = total_abilities / group[1].size
      average.total = total_totals / group[1].size
      average.completed_date = group[0]

      #store
      avg_scores.push(average)
    end
    return avg_scores
  end


  def compute_percent_improvement(second, first, trainee)

    second_score  = Score.find_by(:assignment_id => second.id, :trainee_id => trainee.id)
    first_score   = Score.find_by(:assignment_id => first.id, :trainee_id => trainee.id)

    percent_improvement = Hash.new

    if first_score.knowledge and second_score.knowledge

      percent_improvement['knowledge'] = ((second_score.knowledge - first_score.knowledge) / first_score.knowledge.to_f) * 100
      percent_improvement['skills'] = ((second_score.skills - first_score.skills) / first_score.skills.to_f) * 100
      percent_improvement['abilities'] = ((second_score.abilities - first_score.abilities) / first_score.abilities.to_f) * 100
      percent_improvement['total'] = ((second_score.total - first_score.total) / first_score.total.to_f) * 100

      # if infinity improvement (i.e. last score is 0) return 0% improvement
      percent_improvement.each do |p|
        if p[1] == Float::INFINITY
          percent_improvement[p[0]] = 0
        end
      end

    else
      percent_improvement['knowledge'] = 0
      percent_improvement['skills'] = 0
      percent_improvement['abilities'] = 0
      percent_improvement['total'] = 0
    end

      return percent_improvement


  end


end
