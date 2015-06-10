class Post < ActiveRecord::Base
  belongs_to :user

  def item
    @item ||= Item.find(asin)
  end
end
