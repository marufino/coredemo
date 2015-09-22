class Color < ActiveRecord::Base
  belongs_to :project

  validates :value, presence: true
  validates :color, presence: true
end
