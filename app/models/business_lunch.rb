class BusinessLunch < ActiveRecord::Base
  validates_presence_of :title, :price, :description
  validates :title, length: {maximum: 255}
  validates :price, length: {maximum: 30}, numericality: true
  validates :description, length: {maximum: 65536}

  serialize       :dish_ids, Array
  attr_accessor   :dish_ids_raw

  def dish_ids_raw
    self.dish_ids.join("\n") unless self.dish_ids.nil?
  end

  def dish_ids_raw=(values)
    self.dish_ids = []
    self.dish_ids=values.split("\n")
  end
end
