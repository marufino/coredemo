class CreateAssignmentsSurveys < ActiveRecord::Migration
  def change
      create_table :assignments_surveys , :id => false do |t|
        t.references :assignment
        t.references :survey
      end
      add_index :assignments_surveys, [:assignment_id, :survey_id]
      add_index :assignments_surveys, :assignment_id
    end
  end

