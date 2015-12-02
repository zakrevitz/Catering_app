ActiveAdmin.register User do
  permit_params :name, :email, :password,:password_confirmation, :user, :admin
  controller do
    def update
      def user_params
        params.require(:user).permit(:name, :email, :password,:password_confirmation, :user, :admin)
      end
      @user = User.find(params[:id])
      if params[:user][:password].blank?
        @user.update_without_password(user_params)
      else
        @user.update_attributes(user_params)
      end
      if @user.errors.blank?
        redirect_to admin_users_path, :notice => "User updated successfully."
      else
        render :edit
      end
    end
  end

  filter :name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :locked_at
  filter :failed_attempts
  filter :last_sign_in_at
  filter :daily_rations

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :admin
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :reset_password_sent_at
      row :remember_created_at
      row :sign_in_count
      row :current_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_at
      row :last_sign_in_ip
      row :failed_attempts
      row :locked_at
      row :created_at
      row :updated_at
      row ("Admin") { status_tag (user.admin ? "Admin" : "Non-admin"), 
                                (user.admin ? :error : :ok) }
    end
    active_admin_comments
  end

  sidebar "Ordered Rations for last sprint",  only: :show do
    rations = ActiveRecord::Base.connection.execute('SELECT SUM("daily_rations"."price") as "total_price", SUM("daily_rations"."quantity") as "total_quantity" , "dishes"."title", "daily_menus"."day_number"  FROM "daily_rations" INNER JOIN "dishes" ON "dishes"."id" = "daily_rations"."dish_id" INNER JOIN "daily_menus" ON "daily_menus"."id" = "daily_rations"."daily_menu_id" WHERE "daily_rations"."user_id" = '"#{user.id}"' AND "daily_rations"."sprint_id" = '"#{Sprint.last.id}"' GROUP BY "day_number", "title","daily_rations"."daily_menu_id" ORDER BY "daily_rations"."daily_menu_id"ASC')
    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    rations = rations.group_by{|x| x['day_number']}
    rations.each do |k, v|
      ul h3(days[k.to_i-1])
      v.each do |dish|
        li "#{dish['title']} x#{dish['total_price']} #{dish['total_quantity']} UAH"
      end
      hr
    end
  end

  create_or_edit = Proc.new {
    @user = User.where(id: params[:id]).first_or_create
    @user.save
  }

end
