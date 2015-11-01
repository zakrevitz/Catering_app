module API
 module Version1 
  class Dishes < Grape::API

    version 'v1', using: :path

      resource :dishes do
        
        before do
          error!("401 Unauthorized", 401) unless user_signed_in?
        end

        desc "Returns sorted dishes"
        get "/" do
          Dish.order(id: :desc).all
        end
        
        helpers do
          def clean_params(params)
            #Needs in improvement!
            ActionController::Parameters.new(params)
          end
        end

        desc "Create new dish"
        params do
          group :dish, type: Hash do
            requires :title, :type => String, :desc => "Title"
            requires :price, :type => Float, :desc => "Price"
            requires :description, :type => String, :desc => "Description"
            requires :category_id, :type => Integer, :desc => "Category"
          end
        end

        post '/' do
          @dish = Dish.new
          #Handling ActiveRecord strong parameters needed!
          safe_params = clean_params(params).require(:dish).permit(:title, 
                                                                   :price, 
                                                                   :description, 
                                                                   :category_id)
          if @dish.update_attributes(safe_params)
            @dish
          else
            error!({:errors => @dish.errors}, 422)
          end
        end

        desc "Edit a Dish"
        params do
          group :dish, type: Hash do
            optional :title, :type => String, :desc => "Title"
            optional :price, :type => Float, :desc => "Price"
            optional :description, :type => String, :desc => "Description"
            optional :category_id, :type => Integer, :desc => "Category"
          end
        end
        put '/:id' do
          @dish = Dish.find(params[:id])
          safe_params = clean_params(params).require(:dish).permit(:title, 
                                                                   :price, 
                                                                   :description, 
                                                                   :category_id)
          if @dish.update_attributes(safe_params)
            @dish
          end
        end

        desc "Return dish info"
        get "/:id" do
          @dish = Dish.find(params[:id])
          @dish
        end

        desc "Delete dish"
        delete "/:id" do
          @dish = Dish.find(params[:id])
          @dish.destroy
        end


      end

  end
 end
end