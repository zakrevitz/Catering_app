ActiveAdmin.register DailyMenu do
  permit_params :day_number, :max_total, :active, dish_ids:[]
  scope :all, :default => true
  scope :active do |daily_menus|
    daily_menus.where(:active => true)
  end
  scope :pending do |daily_menus|
    daily_menus.where(:active => false)
  end

  form do |f|
    f.inputs "Daily Menu" do
      f.input :day_number, :as => :radio, :collection => { 'Monday'    => 1, 
                                                           'Tuesday'   => 2,
                                                           'Wednesday' => 3,
                                                           'Thursday'  => 4,
                                                           'Friday'    => 5,
                                                           'Saturday'  => 6,
                                                           'Sunday'    => 7 }
      f.input :max_total
      f.input :dish_ids,
                label: 'Dishes',
                as: :select,
                multiple: true,
                collection: Dish.all,#option_groups_from_collection_for_select(Category.includes(:dishes), :dishes, :title, :id, :title, :id),
                input_html: { class: 'select-two'}
      f.input :active
    end
    actions
  end
end
