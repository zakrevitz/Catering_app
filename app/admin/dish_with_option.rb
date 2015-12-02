ActiveAdmin.register DishWithOption do
  menu parent: 'Dish'
  permit_params :category_id, :title, :price, :description, dish_options_attributes: [:price, :title]
  
  index do
    selectable_column
    id_column
    column :title
    column :description
    column :price
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :price
    end
    panel "Options" do
      table_for dish_with_option.dish_options do
        column "Title" do |dish_option|
          dish_option.title
        end
        column "Price" do |dish_option|
          dish_option.price
        end
      end
    end
  end
  form do |f|
    f.inputs "Dish With Options" do
      f.input :category
      f.input :title, as: :string
      f.input :description, :input_html => { :class => 'autogrow', :rows => 1, :cols => 10, :maxlength => 10  }
      f.input :price
      f.has_many :dish_options do |d_opts|
        d_opts.input :title, as: :string
        d_opts.input :price
      end
    end
    actions
  end
end
