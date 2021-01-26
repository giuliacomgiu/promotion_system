class AddCreatorToPromotions < ActiveRecord::Migration[6.1]
  def change
    add_reference :promotions, :creator,foreign_key: { to_table: :users }
  end
end
