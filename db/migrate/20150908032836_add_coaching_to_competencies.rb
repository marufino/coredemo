class AddCoachingToCompetencies < ActiveRecord::Migration
  def change
    add_column :competencies, :coaching, :text
  end
end
