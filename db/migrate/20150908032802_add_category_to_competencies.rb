class AddCategoryToCompetencies < ActiveRecord::Migration
  def change
    add_column :competencies, :category, :string
  end
end
