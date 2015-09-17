class CreateAreaOfWeaknessesCompetencies < ActiveRecord::Migration
  def change
    create_table :area_of_weaknesses_competencies , :id => false do |t|
      t.references :area_of_weakness
      t.references :competency
    end
    add_index :area_of_weaknesses_competencies, [:area_of_weakness_id, :competency_id], name: 'aow_c'
    add_index :area_of_weaknesses_competencies, :area_of_weakness_id, name: 'aow'
  end
end
