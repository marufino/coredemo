class CreateAreaOfWeaknesses < ActiveRecord::Migration
  def change
    create_table :area_of_weaknesses do |t|
      t.belongs_to :score , index: true
      t.timestamps
    end
  end
end
