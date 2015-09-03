class Observer < ActiveRecord::Base

  has_and_belongs_to_many :projects

  has_one :user, as: :meta, dependent: :destroy

  accepts_nested_attributes_for :user

  def self.options_for_select
    order('id').map { |e| [e.user.full_name, e.id] }
  end

end
