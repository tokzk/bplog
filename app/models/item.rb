class Item
  include ActiveAttr::Model

  attribute :title
  attribute :author
  attribute :manufacturer
  attribute :product_group
  attribute :asin
  attribute :image_url

  def self.search(search_term, item_page)
    @res  = Amazon::Ecs.item_search(search_term, { search_index: 'Books',
                                                   item_page: item_page,
                                                   sort: 'salesrank',
                                                   country: 'jp'})
    begin
      @imgs = Amazon::Ecs.item_search(search_term, { response_group: 'Images',
                                                     search_index: 'Books',
                                                     item_page: item_page,
                                                     sort: 'salesrank',
                                                     country: 'jp' })
    rescue => e
      logger.debug e.message
      logger.debug @res
    end

    items = @res.items.map.with_index do |item, n|
      item_attributes = item.get_element('ItemAttributes')
      item = Item.new
      item.title  = item_attributes.get('Title')
      item.author = item_attributes.get('Author')
      item.manufacturer = item_attributes.get('Manufacturer')
      item.product_group = item_attributes.get('ProductGroup')
      item.asin = @imgs.items[n].get('ASIN')
      item.image_url = @imgs.items[n].get('SmallImage/URL')
      item
    end
    total_count = @res.total_results > 100 ? 100 : @res.total_results
    [items, total_count]
  end
  
end
