require 'amazon/ecs'

class ItemsController < ApplicationController
  def index
    search_term = params[:search] || 'harry potter'
    item_page = params[:page] || '1'
    @res  = Amazon::Ecs.item_search(search_term, { search_index: 'Books',
                                                   item_page: item_page,
                                                   sort: 'salesrank',
                                                   country: 'jp'})
    @imgs = Amazon::Ecs.item_search(search_term, { response_group: 'Images',
                                                   search_index: 'Books',
                                                   item_page: item_page,
                                                   sort: 'salesrank',
                                                   country: 'jp' })
                                                               
  end
end
