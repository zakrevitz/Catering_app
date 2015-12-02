module API
 module Version1 
  class Dishes < Grape::API

    version 'v1', using: :path

      resource :dishes do
        
        before do
          error!("401 Unauthorized", 401) unless user_signed_in?
        end
        
        desc "Add/remove dish to user favourites"
        post "/like" do
          APIHelper.like(params[:id], current_user.id)
          params
        end 
      end
  end
 end
end