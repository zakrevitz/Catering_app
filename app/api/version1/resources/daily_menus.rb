module API
 module Version1 
  class Dailymenus < Grape::API

    version 'v1', using: :path

      resource :dailymenus do
        before do
          error!("401 Unauthorized", 401) unless user_signed_in?
        end
        
        desc "Get menus for actual sprint"
        get '/' do
          menus = APIHelper.get_menus(current_user.id)
          menus ? menus : error!("Forbidden", 403)
        end
      end

  end
 end
end