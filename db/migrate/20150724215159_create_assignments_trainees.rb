class CreateAssignmentsTrainees < ActiveRecord::Migration
  def change
      create_table :assignments_trainees , :id => false do |t|
        t.references :assignment
        t.references :trainee
      end
      add_index :assignments_trainees, [:assignment_id, :trainee_id]
      add_index :assignments_trainees, :assignment_id
    end
  end

