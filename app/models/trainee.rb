class Trainee < ActiveRecord::Base

  #has_many assignments
  #has_many scores

  has_one :user, as: :meta, dependent: :destroy

  accepts_nested_attributes_for :user

end
