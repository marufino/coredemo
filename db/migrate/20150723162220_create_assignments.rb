class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :trainee, index: true
      t.timestamps
    end
  end
end
