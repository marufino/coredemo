class CreateObservers < ActiveRecord::Migration
  def change
    create_table :observers do |t|
      t.belongs_to :project, index: true
      t.timestamps
    end
  end
end
