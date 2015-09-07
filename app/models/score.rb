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
              ]

  has_many :ratings
  belongs_to :trainee
  belongs_to :assignment

  accepts_nested_attributes_for :ratings

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
