class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles

  accepts_nested_attributes_for :roles

  belongs_to :meta, polymorphic: true

  def role?(role)
    return !!self.roles.find_by_name(role)
  end

  def trainee?
    return (self.meta_type == 'Trainee')
  end

  def observer?
    return (self.meta_type == 'Observer')
  end

  def full_name
    return self.first_name + ' ' + self.last_name
  end

  def self.options_for_select
    order('LOWER(last_name)').map { |e| [e.last_name, e.id] }
  end

end
