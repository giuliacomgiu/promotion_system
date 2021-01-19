class AddMaximumDiscountToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_column :promotions, :maximum_discount, :decimal
  end
end
