class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  has_many :items, through: :line_items
  belongs_to :user

  def total
    total = 0
    self.items.each do |item|
      total += (item.price * item.line_items.find_by(item_id: item.id).quantity)
    end
    total
  end

  def add_item(item_id)
    line_item = self.line_items.find_by(item_id: item_id)
      if line_item
        line_item.quantity += 1
        line_item
      else
        line_item = self.line_items.build(item_id: item_id, quantity: 1)
      end
    line_item
  end

  def checkout
    self.status = "submitted"
    update_inventory
  end

  def update_inventory
    if self.status = "submitted"
      self.line_items.each do |line_item|
        line_item.item.inventory -= line_item.quantity
        line_item.item.save
        line_item.delete
      end
      Cart.find(self.id).delete
      self.user.current_cart_id = nil
      self.user.current_cart = nil
      save
    end
  end

end
