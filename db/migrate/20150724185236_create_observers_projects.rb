class CreateObserversProjects < ActiveRecord::Migration
  def change
    create_table :observers_projects , :id => false do |t|
        t.references :observer
        t.references :project
      end
      add_index :observers_projects, [:observer_id, :project_id]
      add_index :observers_projects, :observer_id
    end
  end

