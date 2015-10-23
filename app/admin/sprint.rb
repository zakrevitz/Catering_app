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
ActiveAdmin.register Sprint do
  permit_params :title, :started_at, :finished_at
  
  member_action :start, method: :get
  member_action :pend, method: :get

  controller do

    def start
      @sprint = Sprint.find(params[:id])
      if @sprint.start!
        redirect_to resource_path, notice: "Started!"
      else
        redirect_to resource_path, notice: "Can't do this!"
      end
    end
    
    def pend
      @sprint = Sprint.find(params[:id])
      if @sprint.pend!
        redirect_to resource_path, notice: "Pending again!"
      else 
        redirect_to resource_path, notice: "Already pended!"
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :started_at
    column :finished_at
    column :aasm_state
    actions defaults: true do |sprint|
      link_to("Start", start_admin_sprint_path(sprint), class: "member_link") +
      link_to("Pend", pend_admin_sprint_path(sprint), class: "member_link")
    end
  end

  form do |f|
    f.inputs "Sprint Details" do
      f.semantic_errors *f.object.errors.keys
      f.input :title, :input_html => { :class => 'fixed', :rows => 1}
      f.input :started_at, as: :datepicker, datepicker_options: { min_date:  (Time.now.strftime "%Y-%m-%d"), max_date: "+3M"}
      f.input :finished_at, as: :datepicker, datepicker_options: { min_date: (Time.now.strftime "%Y-%m-%d"), max_date: "+1Y"}
      f.input :aasm_state, :as => :select, :collection => ["Started", "Finished"]
    end
    f.actions
  end
end
