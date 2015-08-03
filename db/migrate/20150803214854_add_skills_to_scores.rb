class AddSkillsToScores < ActiveRecord::Migration
  def change
    add_column :scores, :skills, :integer
  end
end
