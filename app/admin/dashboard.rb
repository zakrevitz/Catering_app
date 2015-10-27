ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }
  content title: proc{ I18n.t("active_admin.dashboard") } do
     columns do
       column do
         panel "Recent Dishes" do
           ul do
             Dish.last(5).map do |dish|
               li link_to(dish.title, admin_dish_path(dish))
             end
           end
         end
       end

       

       column do
         panel "Recent Categoties" do
           ul do
             Category.last(5).map do |category|
               li link_to(category.title, admin_category_path(category))
             end
           end
         end
       end

       column do
         panel "Sprints" do
         #.where('due_date > ? and due_date < ?', Time.now, 1.week.from_now) do |t|
           table_for Sprint.all do |t|
             t.column("Title") { |sprint| link_to sprint.title, admin_sprint_path(sprint) }
           end
         end
       end
     end #columns
  end # contents
end
