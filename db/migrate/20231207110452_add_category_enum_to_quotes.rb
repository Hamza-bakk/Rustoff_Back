class AddCategoryEnumToQuotes < ActiveRecord::Migration[7.1]
  def change
    add_column :quotes, :category_enum, :integer
  end
end
