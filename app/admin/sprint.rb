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
  member_action :close, method: :get

  scope :all, :default => true
  scope :started do |sprints|
    sprints.where(:aasm_state => "started")
  end
  scope :pending do |sprints|
    sprints.where(:aasm_state => "pending")
  end
  scope :closed do |sprints|
    sprints.where(:aasm_state => "closed")
  end

  controller do

    def start
      @sprint = Sprint.find(params[:id])
      if @sprint.start!
        redirect_to resource_path, notice: "Started!"
      else
        redirect_to resource_path, notice: "Can't do this!"
      end
    end

    def close
      @sprint = Sprint.find(params[:id])
      if @sprint.close!
        redirect_to resource_path, notice: "Closed!"
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
    column :title
    column :started_at
    column :finished_at
    column :aasm_state
    actions defaults: true do |sprint|
      link_to("Start", start_admin_sprint_path(sprint), class: "member_link") +
      link_to("Pend", pend_admin_sprint_path(sprint), class: "member_link") +
      link_to("Close", close_admin_sprint_path(sprint), class: "member_link")
    end
  end
  show do
    attributes_table do
      row :title
      row :started_at
      row :finished_at
      #  { status tag ( Here goes +case+ to choose output text ),
      #               ( Here goes +case+ to choose tag color ) }
      row ("State") { status_tag (case sprint.aasm_state
                                   when "pending"
                                    "Pending"
                                   when "started"
                                    "Started"
                                   else 
                                    "Closed"
                                   end ), 
                                 (case sprint.aasm_state
                                   when "pending"
                                    :warning
                                   when "started"
                                    :ok
                                   else 
                                    :error
                                   end ) }
      row :created_at
      row :updated_at
    end
    panel "Daily rations ordered" do
      table_for sprint.daily_rations.order(:user_id) do |daily_ration|
        column "Actions" do |daily_ration|
          link_to("Show", admin_daily_ration_path(daily_ration))
        end
      end
    end
  end
  #{ status_tag (sprint.aasm_state=="pending" ? "Pending" : "Started"), 
  #      (sprint.aasm_state=="pending" ? :error : :ok) }
  form do |f|
    f.inputs "Sprint Details" do
      f.semantic_errors *f.object.errors.keys
      f.input :title, :input_html => { :class => 'fixed', :rows => 1}
      f.input :started_at, as: :datepicker, datepicker_options: { min_date:  (Time.now.strftime "%Y-%m-%d"), max_date: "+3M"}
      f.input :finished_at, as: :datepicker, datepicker_options: { min_date: (Time.now.strftime "%Y-%m-%d"), max_date: "+1Y"}
      f.input :aasm_state, :as => :select, :collection => ["started", "closed"]
    end
    f.actions
  end
end
