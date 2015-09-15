class CreateAreaOfStrengths < ActiveRecord::Migration
  def change
    create_table :area_of_strengths do |t|
      t.belongs_to :score , index: true
      t.timestamps
    end
  end
end
