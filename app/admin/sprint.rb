ActiveAdmin.register Sprint do
  permit_params :title, :started_at, :finished_at
  
  member_action :start, method: :get
  member_action :pend, method: :get
  member_action :close, method: :get
  member_action :pdf, method: :get
  member_action :detailed_pdf, method: :get

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
        redirect_to resource_path, notice: "Can't do this! Can be only one active sprint"
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

    # Print overall meal needs for sprint 
    def pdf
      @sprint = Sprint.find(params[:id])
      path = resource_path+'.pdf'
      redirect_to path
    end

    # Print detailed pdf with rations grouped by user and by day
    def detailed_pdf
      @sprint = Sprint.find(params[:id])
      path = resource_path+'.pdf?detailed=true'
      redirect_to path
    end

    def show
      super do |format|
        format.pdf { 
          pdf = SprintPdf.new(resource)
          if params[:detailed].present?
            pdf.detailed_pdf
            send_data pdf.render, filename: "Sprint_detailed_status.pdf",
                               disposition: "inline"
          else
            pdf.overall_pdf
            send_data pdf.render, filename: "Sprint_status.pdf",
                                 disposition: "inline"
          end
        }
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
    actions do |sprint|
      link_to("Start", start_admin_sprint_path(sprint), class: "member_link") +
      link_to("Pend", pend_admin_sprint_path(sprint), class: "member_link") +
      link_to("Close", close_admin_sprint_path(sprint), class: "member_link") +
      link_to("PDF", pdf_admin_sprint_path(sprint), class: "member_link")
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
      row ('Reports:') {
        link_to("Overall PDF", pdf_admin_sprint_path(sprint), class: "member_link") +
        link_to("Detailed PDF", detailed_pdf_admin_sprint_path(sprint), class: "member_link")
      }
    end
    
  end

  # This responsible for sidebar with detailed info on sprint ordered rations
  sidebar "Daily rations ordered", only: :show do
      @sprint = Sprint.find(params[:id])
      queue = 'SELECT SUM("daily_rations"."price") as "price_sum", SUM("daily_rations"."quantity") as "quantity_sum" ,"dish_options"."title" as "optional_title", "dishes"."title", "users"."name",  "daily_menus"."day_number" FROM "daily_rations" INNER JOIN "users" ON "users"."id" = "daily_rations"."user_id" INNER JOIN "dishes" ON "dishes"."id" = "daily_rations"."dish_id" LEFT JOIN "dish_options" ON "daily_rations"."dish_option_id"="dish_options"."id" INNER JOIN "daily_menus" ON "daily_rations"."daily_menu_id"="daily_menus"."id" WHERE "daily_rations"."sprint_id" = '"#{@sprint.id}"' GROUP BY"dishes"."title", "daily_menus"."day_number", "users"."name","dish_options"."title" ORDER BY  "daily_menus"."day_number"ASC'
      _rations = ActiveRecord::Base.connection.execute(queue)
      days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
      grouped_rations = _rations.group_by{|x| x['day_number']}
      grouped_rations.each do |k,v|
        h2(days[k.to_i-1])
        grouped_users = v.group_by{|x| x['name']}
        grouped_users.each do |k,v|
          ul { h3(k) }
            v.each do |dish|
              if dish['optional_title']
                li "#{dish['title']} #{dish['optional_title']} x#{dish['quantity_sum']} #{dish['price_sum']} UAH"
              else
                li "#{dish['title']} x#{dish['quantity_sum']} #{dish['price_sum']} UAH"
              end
            end
          hr
        end
        br
      end
    end
    
  form do |f|
    f.inputs "Sprint Details" do
      f.semantic_errors *f.object.errors.keys
      f.input :title, as: :string
      f.input :started_at, as: :datepicker, datepicker_options: { min_date:  (Time.now.strftime "%Y-%m-%d"), max_date: "+3M"}
      f.input :finished_at, as: :datepicker, datepicker_options: { min_date: (Time.now.strftime "%Y-%m-%d"), max_date: "+1Y"}
      f.input :aasm_state, :as => :select, :collection => ["started", "closed"], :label => "State (leave blank for \"Pending\" state)"
    end
    f.actions
  end
end
