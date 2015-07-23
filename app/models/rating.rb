class Rating < ActiveRecord::Base

  belongs_to :observer

  validates :value, :presence => true

end
