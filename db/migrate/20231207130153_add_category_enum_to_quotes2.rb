class AddCategoryEnumToQuotes2 < ActiveRecord::Migration[7.1]
  def change
    add_column :quotes, :category_enum, :integer
  end
end
