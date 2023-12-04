class RemoveAdminIdFromQuotes < ActiveRecord::Migration[7.0]
  def change
    remove_column :quotes, :admin_id, :integer
  end
end
