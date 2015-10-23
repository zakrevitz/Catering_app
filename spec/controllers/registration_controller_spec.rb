require 'rails_helper'

RSpec.describe RegistrationController, type: :controller do

  describe "GET #sign_up_params" do
    it "returns http success" do
      get :sign_up_params
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #account_update_params" do
    it "returns http success" do
      get :account_update_params
      expect(response).to have_http_status(:success)
    end
  end

end
