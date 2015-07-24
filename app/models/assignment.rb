class Assignment < ActiveRecord::Base

  has_and_belongs_to_many :trainee
  has_one :survey

end
