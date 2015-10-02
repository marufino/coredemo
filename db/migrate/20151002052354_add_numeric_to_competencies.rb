class AddNumericToCompetencies < ActiveRecord::Migration
  def change
    add_column :competencies, :numeric, :boolean
  end
end
