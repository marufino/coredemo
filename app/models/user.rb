class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles

  accepts_nested_attributes_for :roles

  belongs_to :meta, polymorphic: true

  has_attached_file :avatar, styles: { medium: "300x300#", thumb: "50x50#" }, default_url: "default_profile.jpg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

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

  def initial_last_name
    return self.first_name[0] + '. ' + self.last_name
  end

  def self.options_for_select_trainee
    order('LOWER(last_name)').map { |e| [e.last_name, e.meta.id] }
  end

  def self.import(file)
    if file
      spreadsheet = Roo::Spreadsheet.open(file, :extension => 'xls')
      header = spreadsheet.row(1)
      if header == ["first_name", "last_name", "email", "phone", "meta_type", "title"]
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          user = find_by_email(row["email"]) || new
          user.attributes = row.to_hash.slice(*row.to_hash.keys)
          if user.meta_id == nil
            generated_password = Devise.friendly_token.first(8)
            user.password = generated_password
          end
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


  def get_picture(email)


    byebug
    # register API key
    client = LinkedIn::Client.new('77jwgldr7lxmyq', 'OAtow3zeU72iWwkD')

    request_token = client.request_token({}, :scope => "r_basicprofile")

    # or authorize from previously fetched access keys
    client.authorize_from_access("92b97262-7d6d-478c-b91a-9f16b722d7b9", "43d4aef2-ed94-4698-b755-b7101a963acb")

    # retrieve picture from linkedin api
    picture = client.profile(:email => email, :fields => ['picture-url'])
    user = client.profile(:fields => %w(picture-url))

    # add to user model
    if picture
      u = User.find_by_email(email).picture = picture
      u.save
    end

  end


end
