class Competency < ActiveRecord::Base

  has_and_belongs_to_many :area_of_strength
  has_and_belongs_to_many :area_of_weakness

  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file, :extension => 'xls')
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      competency = find_by_name(row["name"]) || new
      competency.attributes = row.to_hash.slice(*row.to_hash.keys)
      competency.save!
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

  def self.options_for_select
    order('id').map { |e| [e.name, e.id] }
  end

end
