class LineItemsController < ApplicationController
  def create
    current_user.create_current_cart unless current_user.current_cart
    if current_user.current_cart.items.include?(Item.find(params[:item_id]))
      @item = current_user.current_cart.line_items.find_by(item_id: params[:item_id])
      @item.quantity += 1
    else
      @item = current_user.current_cart.add_item(params[:item_id])
    end
    if @item.save
      redirect_to cart_path(current_user.current_cart), {notice: "Item added to cart!"}
    else
      redirect_to store_path, {notice: "Unable to add item"}
    end
  end
end
 
