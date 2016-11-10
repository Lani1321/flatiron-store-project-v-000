class CartsController < ApplicationController
  def show
    @cart = Cart.find(params[:id])
    @user = current_user
  end

  def checkout
    current_cart.checkout
    redirect_to cart_path(current_cart)
  end

end
