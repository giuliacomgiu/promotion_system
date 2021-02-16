class AddCodeIndexToPromotions < ActiveRecord::Migration[6.1]
  def change
    add_index :promotions, :code, unique: true
  end
end
