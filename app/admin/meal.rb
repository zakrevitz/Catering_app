ActiveAdmin.register Meal do
  menu parent: 'Dish'
  permit_params :category_id, :title, :price, :description
  form do |f|
    f.inputs "Single Meal" do
      f.input :category, :input_html => {class: 'select-two'}
      f.input :title, as: :string
      f.input :description, :input_html => { :class => 'autogrow', :rows => 1, :cols => 10, :maxlength => 10  }
      f.input :price
    end
    actions
  end
end
