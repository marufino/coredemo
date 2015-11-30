class AddCommentsToScores < ActiveRecord::Migration
  def change
    add_column :scores, :comments, :text
  end
end
