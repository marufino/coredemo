class Score < ActiveRecord::Base

  filterrific :default_filter_params => { :sorted_by => 'completed_at_desc' },
              :available_filters => %w[
                sorted_by
                search_query
                with_trainee_id
                with_created_at_gte
                with_survey
                with_observer_id
                with_project
                with_area_of_strength
                with_area_of_weakness
              ]

  has_many :ratings
  has_one :area_of_strength
  has_one :area_of_weakness
  belongs_to :trainee
  belongs_to :assignment

  accepts_nested_attributes_for :ratings

  def calculate_scores(ratings,questions)

    blocks = self.assignment.surveys[0].survey_blocks

    # pull areas of strength and areas of weakness
    rating_map = ratings.zip(questions).sort!

    a_s = AreaOfStrength.where(:score_id => self.id).first
    a_w = AreaOfWeakness.where(:score_id => self.id).first

    3.times do
      a_s.competencies.build
      a_w.competencies.build
    end

    rating_map.last(3).each do |r|
      a_s.competencies << Competency.find_by_name(r[1].category)
    end

    rating_map.first(3).each_with_index do |r,i|
      a_w.competencies << Competency.find_by_name(r[1].category)
    end


    self.area_of_strength_id = a_s.id
    self.area_of_weakness_id = a_w.id


    num_options = 6.0
    knowledge = 0
    abilities = 0
    skills= 0
    #generate CORE Scores
    questions.each_with_index do |q,i|
      if q.survey_block.category == 'Knowledge'
        knowledge = knowledge + ratings[i].to_i * q.weight/num_options
      end
      if q.survey_block.category == 'Skills'
        skills = skills + ratings[i].to_i * q.weight/num_options
      end
      if q.survey_block.category == 'Ability'
        abilities = abilities + ratings[i].to_i * q.weight/num_options
      end
    end

    self.knowledge  = knowledge * 100.0/blocks[0].weight
    self.skills     = skills * 100.0/blocks[1].weight
    self.abilities  = abilities * 100.0/blocks[2].weight
    self.total      = knowledge+abilities+skills
  end


  # default for will_paginate
  self.per_page = 20

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^completed_at_/
        order("completed_date #{ direction }")
      when /^assigned_at_/
        order("assigned_date #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :search_query, lambda { |query|
     return nil  if query.blank?
     # condition query, parse into individual keywords
     terms = query.downcase.split(/\s+/)
     # replace "*" with "%" for wildcard searches,
     # append '%', remove duplicate '%'s
     terms = terms.map { |e|
       (e.gsub('*', '%') + '%').gsub(/%+/, '%')
     }
     # configure number of OR conditions for provision
     # of interpolation arguments. Adjust this if you
     # change the number of OR conditions.
     num_or_conditions = 3
     where(
         terms.map {
           or_clauses = [
               "trainee.user.first_name LIKE ?",
               "trainee.user.last_name LIKE ?",
               "assignment.name LIKE ?"
           ].join(' OR ')
           "(#{ or_clauses })"
         }.join(' AND '),
         *terms.map { |e| [e] * num_or_conditions }.flatten
     )
   }

  scope :with_trainee_id, lambda { |trainee_ids|
    where(:trainee_id => [*trainee_ids])
  }

  scope :with_observer_id, lambda { |observer_ids|
    obs = Observer.where(:id => [*observer_ids])
    ass = Assignment.where(:project_id => obs.first.projects.ids)
    where(:assignment_id => ass.ids)
  }

  scope :with_survey, lambda { |survey_id|
    where(:assignment_id => Assignment.where(:survey_id => [*survey_id]))
  }

  scope :with_project, lambda { |project_id|
    where(:assignment_id => Assignment.where(:project_id => [*project_id]))
  }

  scope :with_area_of_strength, lambda { |competency_id|
    comp = Competency.find_by_id([*competency_id])
    where(:area_of_strength_id => comp.area_of_strength.ids)
  }

  scope :with_area_of_weakness, lambda { |competency_id|
    comp = Competency.find_by_id([*competency_id])
    where(:area_of_weakness_id => comp.area_of_weakness.ids)
  }


  def self.options_for_sorted_by
    [
        ['Assigned date (newest first)', 'assigned_at__desc'],
        ['Assigned date (oldest first)', 'assigned_at__asc'],
        ['Completed date (newest first)', 'completed_at_desc'],
        ['Completed date (oldest first)', 'completed_at_asc']
    ]
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |score|
        csv << score.attributes.values_at(*column_names)
      end
    end
  end


end
