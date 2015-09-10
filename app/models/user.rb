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

  def self.options_for_select_trainee
    order('LOWER(last_name)').map { |e| [e.last_name, e.meta.id] }
  end

  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file, :extension => 'xls')
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = find_by_email(row["email"]) || new
      user.attributes = row.to_hash.slice(*row.to_hash.keys)
      user.password = 'password'
      if(user.meta_type=='Trainee' and user.meta_id == nil)
        trainee = Trainee.new
        user.meta = trainee
      elsif(user.meta_type=='Observer' and user.meta_id == nil)
        observer = Observer.new
        user.meta = observer
      end
      user.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
