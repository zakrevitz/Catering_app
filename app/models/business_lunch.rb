# == Schema Information
#
# Table name: dishes
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  title        :text             not null
#  description  :text
#  price        :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  type         :string(45)
#  children_ids :integer          default([]), is an Array
#

class BusinessLunch < Dish
  before_save :sanitaze_children_ids

  validates_presence_of :children_ids

  belongs_to :category

  private
    def sanitaze_children_ids
      self.children_ids = self.children_ids.select { |dish| !dish.nil? }
    end
end
