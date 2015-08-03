class AddKnowledgeToScores < ActiveRecord::Migration
  def change
    add_column :scores, :knowledge, :integer
  end
end
