class Assignment < ActiveRecord::Base

  belongs_to :trainee
  has_one :survey

end
