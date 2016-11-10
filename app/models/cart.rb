class Cart < ActiveRecord::Base
  has_many :line_items
  has_many :items, through: :line_items
  belongs_to :user


  # line item has many items, so we can grab the price of the item through line item
  def total
    total = 0
    line_items.each do |line_item|
      total += line_item.item.price * line_item.quantity
    end
    total
  end

  # creates a new unsaved line_item for new item
  # creates an appropriate line_item
  # updates existing line_item instead of making new when adding same item
  def add_item(item_id)
    line_item = line_items.find_by(item_id: item_id)
    if line_item
      line_item.quantity += 1
    else
      line_item = self.line_items.build(item_id: item_id)
    end
    line_item
  end

  def checkout
    self.status = 'submitted'
    line_items.each do |line_item|
      remove_inventory(line_item)
      user.remove_cart
      update(status: 'submitted')
    end
  end

  def remove_inventory(line_item)
    item = Item.find_by_id(line_item.item_id)
    item.inventory -= line_item.quantity
    item.save
  end

  # def checkout
  #   remove_inventory(line_item.id)
  #   user.remove_cart
  #   update(status: 'submitted')
  # end

  # def clear_inventory
  #   line_items.each do |line_item|
  #     line_item.item.remove_cart(line_item.quantity)
  #   end
  # end

end
