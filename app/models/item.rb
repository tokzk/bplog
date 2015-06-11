class Item
  def initialize(item)
    @item = item
    @attr = @item.get_element('ItemAttributes')
  end

  def asin
    @item.get('ASIN')    
  end

  def title
    @attr.get('Title')
  end

  def author
    @attr.get_array("Author").join(", ")
  end

  def manufacturer
    @attr.get('Manufacturer')
  end

  def product_group
    @attr.get('ProductGroup')
  end

  def item_binding
    @attr.get('Binding')
  end

  def url
    @attr.get('DetailPageURL')
  end

  def isbn
    @attr.get('ISBN')
  end

  def image_url
    @item.get('MediumImage/URL')
  end

  def release_date
    @attr.get('ReleaseDate') || @attr.get('PublicationDate')
  end

  class << self

    def find(asin)
      return if asin.nil?
      Retriable.retriable tries: 5, base_interval: 1 do
        res = Amazon::Ecs.item_lookup(asin, { response_group: "Medium",
                                              country: 'jp' })
        item = self.new(res.first_item)
        puts item
        item
      end
    end
    
    def search(search_term, page = 1)
      return [[], 0] if search_term.blank?
      Retriable.retriable tries: 5, base_interval: 1 do
        res  = Amazon::Ecs.item_search(search_term, { response_group: 'Medium',
                                                      search_index: 'Books',
                                                      item_page: page,
                                                      sort: 'salesrank',
                                                      country: 'jp'})
        items = res.items.map{ |item| self.new(item) }
        [items, total_count(res)]
      end
    end
  end

  private

  def self.total_count(res)
    res.total_results > 100 ? 100 : res.total_results
  end
end
