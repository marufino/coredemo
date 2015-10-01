class TestScore < ActiveRecord::Base

  belongs_to :trainee
  belongs_to :project


  def has_one?
    return (self.final or self.midterm or self.starting)!= nil
  end

end
