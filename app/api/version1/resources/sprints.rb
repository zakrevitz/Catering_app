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

        before do
          error!("401 Unauthorized", 401) unless user_signed_in?
        end

        desc "Returns sorted sprints"
        get "/history" do
          Sprint.where(aasm_state: ['started', 'closed']).order(id: :asc).all.as_json(except: [:created_at, :updated_at])
        end
        
        helpers do
          def clean_params(params)
            # Needs in improvement!
            ActionController::Parameters.new(params)
          end
        end

        desc "Return all daily ration user made for this sprint."
        get '/:id/rations' do
          # TODO: add dish_options
          DailyRation.includes(:dish, :daily_menu).order(:daily_menu_id)
                     .where(sprint_id: params[:id], 
                            user_id: current_user.id)
                     .as_json(include: { dish: {
                                          only: :title }, 
                                         daily_menu: { 
                                          only: :day_number } }, 
                              except: [:sprint_id, :user_id, :created_at, :updated_at])
        end
      end
  end
 end
end