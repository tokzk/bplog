require 'amazon/ecs'

class ItemsController < ApplicationController
  def index
    search_term = params[:search] || 'harry potter'
    item_page = params[:page] || '1'
    
    items, total_count = Item.search(search_term, item_page)
    @items = Kaminari.paginate_array(items, total_count: total_count).page(params[:page]).per(10)
  end
end
