module API
  module Version1
    class Sessions < ::Grape::API
      version 'v1', using: :path
      format :json
      resource :sessions do

        params do
            requires :email, :type => String, :desc => "email"
            requires :password, :type => String,  :desc => "password"
        end
        post '/sign_in' do
          _user = User.where(email: params[:email]).first

          if _user && _user.valid_password?(params[:password])
            warden.set_user(_user) # THANKS GOD IT WORKING.
            # {'user' => {'name' => _user.name }}
            status 200
            {:auth => true,  :name => _user.name}
          else
            error!('Wrong username or password', 401)
          end
        end

        delete '/sign_out' do
        end
      end
    end
  end
end