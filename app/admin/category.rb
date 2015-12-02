ActiveAdmin.register Category do
  permit_params :title, :sort_order
  form do |f|
    f.inputs "Category" do
      f.input :title, as: :string
      f.input :sort_order
    end
    actions
  end
end
