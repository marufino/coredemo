class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.belongs_to :project
      t.string :color
      t.integer :value

      t.timestamps
    end
  end
end
