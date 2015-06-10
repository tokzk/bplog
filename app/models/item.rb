class Item
  include ActiveAttr::Model

  attribute :asin
  attribute :title
  attribute :author
  attribute :manufacturer
  attribute :product_group
  attribute :url
  attribute :isbn
  attribute :image_url
  attribute :small_image_url
  attribute :medium_image_url
  attribute :large_image_url

  def self.find(asin)
    retry_count = 0
    begin
      res = Amazon::Ecs.item_lookup(asin, { response_group: "Medium",
                                            country: 'jp' })
      item = build(res.first_item)
    rescue => e
      retry_count += 1
      logger.error e.message
      if retry_count < 5
        sleep(2)
        retry
      end
    end
  end
  
  def self.search(search_term, page = 1)
    return [[], 0] if search_term.blank?

    retry_count = 0
    begin
      res  = Amazon::Ecs.item_search(search_term, { response_group: 'Medium',
                                                    search_index: 'Books',
                                                    item_page: page,
                                                    sort: 'salesrank',
                                                    country: 'jp'})
    rescue => e
      retry_count += 1
      logger.error e.message
      if retry_count < 5
        sleep(2)
        retry
      end
    end

    items = res.items.map{ |item| build(item) }
    [items, total_count(res)]
  end

  def self.build(item)
    item_attributes = item.get_element('ItemAttributes')
    Item.new(
      asin:             item.get('ASIN'),
      title:            item_attributes.get('Title'),
      author:           item_attributes.get_array("Author").join(", "),
      manufacturer:     item_attributes.get('Manufacturer'),
      product_group:    item_attributes.get('ProductGroup'),
      url:              item.get('DetailPageURL'),
      isbn:             item_attributes.get('ISBN'),
      image_url:        item.get('LargeImage/URL'),
      small_image_url:  item.get_hash('SmallImage/URL'),
      medium_image_url: item.get_hash('MediumImage/URL'),
      large_image_url:  item.get_hash('LargeImage/URL')
    )
  end

  private

  def self.total_count(res)
    res.total_results > 100 ? 100 : res.total_results
  end
end
