module API
 module Version1 
  class Dishes < Grape::API

    version 'v1', using: :path

      resource :dishes do
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
            requires :price, :type => Float, :desc => "price"
            requires :description, :type => String, :desc => "description"
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