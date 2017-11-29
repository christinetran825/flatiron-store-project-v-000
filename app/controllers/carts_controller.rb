class CartsController < ApplicationController

  helper_method :current_cart

  def current_cart
    current_user.current_cart
  end

  def current_cart=(cart)
    current_user.current_cart = cart
  end

  def show
    @cart = Cart.find(params[:id])
  end

  def checkout
    cart = Cart.find(params[:id])
    cart.checkout
    redirect_to cart_path(cart)
  end

end
