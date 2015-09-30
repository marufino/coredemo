class CreateTestScores < ActiveRecord::Migration
  def change
    create_table :test_scores do |t|
      t.belongs_to :project
      t.belongs_to :trainee
      t.integer :starting
      t.integer :midterm
      t.integer :final

      t.timestamps
    end
  end
end
