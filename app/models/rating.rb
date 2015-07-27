class Rating < ActiveRecord::Base

  belongs_to :observer
  belongs_to :score

end
