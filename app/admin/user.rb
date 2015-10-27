# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
ActiveAdmin.register User do
  
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

    panel "Ordered Rations" do
      table_for user.daily_rations.order(:daily_menu_id) do |daily_ration|
        column :price
        column :quantity
        column "Actions" do |daily_ration|
          link_to("Show", admin_daily_ration_path(daily_ration))
        end
      end
    end
    active_admin_comments
  end

  

  create_or_edit = Proc.new {
    @user = User.where(id: params[:id]).first_or_create
    @user.save
  }

end
