class AddStatusToPromotions < ActiveRecord::Migration[6.1]
  def change
    add_column :promotions, :status, :integer
  end
end
