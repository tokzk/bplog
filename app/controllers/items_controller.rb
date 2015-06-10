class ItemsController < ApplicationController
  def index
    items, total_count = Item.search(params[:search], params[:page])
    @items = Kaminari.paginate_array(items, total_count: total_count).page(params[:page]).per(10)
  end
end
