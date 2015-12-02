module API
 module Version1 
  class DailyRations < Grape::API

    version 'v1', using: :path

      resource :daily_ration do
        
        before do
          error!("401 Unauthorized", 401) unless user_signed_in?
        end

        desc "Create new rations"
        post '/' do
          request = ActiveSupport::JSON.decode( params[:data] )
          if APIHelper.check_rations(request)
            APIHelper.set_rations(request, current_user.id)
          else
            error!("404 YOU CHEEKY BASTARD", 404)
          end
        end

      end

  end
 end
end