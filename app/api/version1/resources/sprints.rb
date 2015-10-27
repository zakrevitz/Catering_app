# == Schema Information
#
# Table name: sprints
#
#  id          :integer          not null, primary key
#  title       :text             not null
#  started_at  :datetime
#  finished_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  aasm_state  :string
#
module API
 module Version1 
  class Sprints < Grape::API

    version 'v1', using: :path

      resource :sprints do
        desc "Returns sorted sprints"
        get "/" do
          Sprint.order(id: :desc).all
        end
        
        helpers do
          def clean_params(params)
            #Needs in improvement!
            ActionController::Parameters.new(params)
          end
        end

        desc "Create new sprint"
        params do
          group :sprint, type: Hash do
            requires :title, :type => String, :desc => "Title"
            requires :started_at, :type => DateTime,  :desc => "Starting date"
            requires :finished_at, :type => DateTime, :desc => "Ending date"
            requires :aasm_state, :type => String , default: 'pending',
                                                      values: ['pending', 'started', 'closed'],
                                                      :desc => "Status"
          end
        end

        post '/' do
          @sprint = Sprint.new
          #Handling ActiveRecord strong parameters needed!
          safe_params = clean_params(params).require(:sprint).permit(:title, 
                                                                   :started_at, 
                                                                   :finished_at, 
                                                                   :aasm_state)
          if @sprint.update_attributes(safe_params)
            @sprint
          else
            error!({:errors => @sprint.errors}, 422)
          end
        end

        #desc "Edit a Sprint"
        #params do
        #  group :sprint, type: Hash do
        #    optional :title, :type => String, :desc => "Title"
        #    optional :started_at, :type => DateTime,  :desc => "Starting date"
        #    optional :finished_at, :type => DateTime, :desc => "Ending date"
        #    optional :aasm_state, :type => String , default: 'pending',
        #                                              values: ['pending', 'started', 'closed'],
        #                                              :desc => "Status"
        #  end
        #end
        #put '/:id' do
        #  @sprint = Sprint.find(params[:id])
        #  safe_params = clean_params(params).require(:sprint).permit(:title, 
        #                                                           :started_at, 
        #                                                           :finished_at, 
        #                                                           :aasm_state)
        #  if @sprint.update_attributes(safe_params)
        #    @sprint
        #  end
        #end

        desc "Return sprint info"
        get "/:id" do
          @sprint = Sprint.find(params[:id])
          @sprint
        end

        #desc "Delete sprint"
        #delete "/:id" do
        #  @sprint = Sprint.find(params[:id])
        #  @sprint.destroy
        #end


      end

  end
 end
end