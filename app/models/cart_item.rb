class CartItem < ApplicationRecord
  belongs_to :cart  # Relation : Un CartItem appartient à un Cart.
  belongs_to :item  # Relation : Un CartItem appartient à un Item.

  
  def total_price
    quantity * item.price 
  end
end