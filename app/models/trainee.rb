class Trainee < ActiveRecord::Base

  has_and_belongs_to_many :assignments
  has_and_belongs_to_many :scores

  has_one :user, as: :meta, dependent: :destroy

  accepts_nested_attributes_for :user

  def get_nth_assignment(n)
    return self.assignments.order('date')[n]
  end

end
