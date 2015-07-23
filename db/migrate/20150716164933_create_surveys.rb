class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.belongs_to :assignment, index: true
      t.timestamps
    end
  end
end
