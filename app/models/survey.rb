class Survey < ActiveRecord::Base

  has_many :survey_blocks
  has_many :questions , through: :survey_blocks
  has_and_belongs_to_many :assignments


  accepts_nested_attributes_for :survey_blocks


  def self.options_for_select
    order('id').map { |e| [e.name, e.id] }
  end

end
