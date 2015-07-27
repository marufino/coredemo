class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.belongs_to :trainee, index: true
      t.belongs_to :assignment, index: true
      t.timestamps
    end
  end
end
