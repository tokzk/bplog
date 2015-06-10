class Item
  include ActiveAttr::Model

  attribute :asin
  attribute :title
  attribute :author
  attribute :manufacturer
  attribute :product_group
  attribute :url
  attribute :image_url

  def self.search(search_term, page = 1)
    return [[], 0] if search_term.blank?
    res  = Amazon::Ecs.item_search(search_term, { response_group: 'Medium',
                                                  search_index: 'Books',
                                                  item_page: page,
                                                  sort: 'salesrank',
                                                  country: 'jp'})

    items = res.items.map.with_index do |item, n|
      item_attributes = item.get_element('ItemAttributes')
      Item.new(
        asin:          item.get('ASIN'),
        title:         item_attributes.get('Title'),
        author:        item_attributes.get('Author'),
        manufacturer:  item_attributes.get('Manufacturer'),
        product_group: item_attributes.get('ProductGroup'),
        url:           item.get('DetailPageURL'),
        image_url:     item.get('LargeImage/URL')
      )
    end
    [items, total_count(res)]
  end

  private

  def self.total_count(res)
    res.total_results > 100 ? 100 : res.total_results
  end
end
