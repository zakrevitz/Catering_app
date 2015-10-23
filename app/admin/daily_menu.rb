# == Schema Information
#
# Table name: daily_menus
#
#  id         :integer          not null, primary key
#  day_number :integer          not null
#  max_total  :float            default(100.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dish_ids   :integer          default([]), is an Array
#
ActiveAdmin.register DailyMenu do
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  # All controller code here only to solve problem when ActiveAdmin 
  #  didn't save Postgresql Array normally.
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 controller do
    def daily_menu_params
      params.require(:daily_menu).permit(:day_number, :max_total, dish_ids:[])
    end

    def create
      params[:daily_menu][:dish_ids].delete("") # Removes all NIL element of array
                                                # HTML adds it in first place in array
      @daily_menu = DailyMenu.new(daily_menu_params)
      @daily_menu.save
      redirect_to resource_path, notice: "Successfully created!"
    end

    def update
      params[:daily_menu][:dish_ids].delete("") # Removes all NIL element of array
                                                # HTML adds it in first place in array
      @daily_menu =  DailyMenu.where(id: params[:id]).first
      @daily_menu.update(daily_menu_params)
      redirect_to resource_path, notice: "Successfully updated!"
    end

  end

 form do |f|
  f.inputs "Dish ids" do
    f.input :day_number, :as => :radio, :collection => ["1", "2", "3", "4", "5", "6", "7"]
    f.input :max_total
    f.input :dish_ids, :as => :select, :collection => Dish.all{|p| [ p.name, p.id ] }, :input_html => {:multiple => true}
  end
  actions
 end

end
