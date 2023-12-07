class RemoveCategoryEnumFromQuotes < ActiveRecord::Migration[7.1]
  def change
    remove_column :quotes, :category_enum, :integer
  end
end
