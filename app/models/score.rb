class Score < ActiveRecord::Base

  filterrific :default_filter_params => { :sorted_by => 'created_at_desc' },
              :available_filters => %w[
                sorted_by
                search_query
                with_trainee_id
                with_created_at_gte
              ]

  has_many :ratings
  belongs_to :trainee
  belongs_to :assignment

  accepts_nested_attributes_for :ratings


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
               "LOWER(scores.trainee.first_name) LIKE ?",
               "LOWER(scores.trainee.last_name) LIKE ?",
               "LOWER(scores.assignment.name) LIKE ?"
           ].join(' OR ')
           "(#{ or_clauses })"
         }.join(' AND '),
         *terms.map { |e| [e] * num_or_conditions }.flatten
     )
   }

  scope :with_trainee_id, lambda { |trainee_ids|
    where(:trainee_id => [*trainee_ids])
  }


  def self.options_for_sorted_by
    [
        ['Name (a-z)', 'name_asc'],
        ['Registration date (newest first)', 'created_at_desc'],
        ['Registration date (oldest first)', 'created_at_asc'],
        ['Country (a-z)', 'country_name_asc']
    ]
  end

end
