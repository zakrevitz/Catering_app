module API
  module Version1
    class Sessions < ::Grape::API
      version 'v1', using: :path
      format :json
      resource :sessions do

        desc "Log in"
        params do
            requires :email, :type => String, :desc => "email"
            requires :password, :type => String,  :desc => "password"
        end
        post '/sign_in' do
          _user = User.where(email: params[:email]).first

          if _user && _user.valid_password?(params[:password])
            warden.set_user(_user) # THANKS GOD IT WORKING. valid_for_authentication?
            {:auth => true,  :name => _user.name, :email => _user.email}
          else
            error!('Wrong username or password', 401)
          end
        end

        desc "Logout"
        delete '/sign_out' do
          warden.logout
        end

        desc "Checks if user logged in"
        params do
            requires :email, :type => String, :desc => "email"
        end
        get '/signed' do
          _user = current_user
          if _user && (_user.email == params[:email])
            {:auth => true,  :name => _user.name, :email => _user.email}
          else
            error!("401 Unauthorized", 401)
          end
        end

      end # resource
    end # class
  end
end