ActiveAdmin.register BusinessLunch do
  menu parent: 'Dish'
  permit_params :category_id, :title, :price, :description, children_ids:[]

  form do |f|
    f.inputs "Business Lunch" do
      f.input :category, :input_html => {class: 'select-two'}
      f.input :title, as: :string
      f.input :description, :input_html => { :class => 'autogrow', :rows => 1, :cols => 10, :maxlength => 10  }
      f.input :price
      f.input :children_ids, :as => :select, :collection => Dish.all, :input_html => {:multiple => true, class: 'select-two'}
    end
    actions
  end

end
