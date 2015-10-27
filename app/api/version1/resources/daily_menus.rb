module API
 module Version1 
  class Dailymenus < Grape::API

    version 'v1', using: :path

      resource :dailymenus do
        desc "Returns sorted daily menus"
        get "/" do
          DailyMenu.order(id: :desc).all
        end
        
        desc "Return dish info"
        get "/:id" do
          @daily_menu = DailyMenu.find(params[:id])
          @daily_menu
        end

      end

  end
 end
end