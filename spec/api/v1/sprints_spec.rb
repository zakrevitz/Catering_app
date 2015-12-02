require 'rails_helper'

RSpec.describe API::Version1::Engine do
  let(:log_in) {FactoryGirl.create(:user, email:"test@test.test", name:"test", password:"12345678", password_confirmation: "12345678")
                _user = {email:"test@test.test", password:"12345678"}
                post '/api/v1/sessions/sign_in', _user.to_json,'CONTENT_TYPE' => 'application/json'}
  let(:create_sprint) { FactoryGirl.create(:sprint, title: "Test sprint", aasm_state: 'started') }
  context 'Session' do
    it 'logins/logouts' do
      log_in
      expect(response.status).to eq 201
      delete '/api/v1/sessions/sign_out'
      expect(response.status).to eq 200
    end

    it 'GET "/signed" returns true when user logged in' do
      log_in
      param = {email:"test@test.test"}
      get '/api/v1/sessions/signed', param, 'CONTENT_TYPE' => 'application/json'
      expect(response.status).to eq 200
      expect(response.body).to have_node(:auth).with(true)
      expect(response.body).to have_node(:name).with('test')
    end

    it 'GET "/signed" returns true when user logged in' do
      param = {email:"test@test.test"}
      get '/api/v1/sessions/signed', param, 'CONTENT_TYPE' => 'application/json'
      expect(response.status).to be_unauthorized
    end

  end

  context 'Sprint' do
    it 'GET "sprints/history" returns list of all sprints' do
      log_in
      create_sprint
      FactoryGirl.create(:sprint, title: "Test sprint №2", aasm_state: 'closed')
      get '/api/v1/sprints/history'
      expect(response.status).to eq 200
      expect(response.body).to have_node(:title).with("Test sprint")
      expect(response.body).to have_node(:title).with("Test sprint №2")
    end

    it 'GET "sprints/history" returns Error 401 if not logged in' do
      get '/api/v1/sprints/history'
      expect(response.status).to be_unauthorized
    end
    
    it 'Get "/:id/rations" returns daily rations' do
      current_user = FactoryGirl.create(:user, email:"test@test.test", name:"test", password:"12345678", password_confirmation: "12345678")
      _user = {email:"test@test.test", password:"12345678"}
      post '/api/v1/sessions/sign_in', _user.to_json,'CONTENT_TYPE' => 'application/json'
      
      _sprint = create_sprint
      daily_ration = FactoryGirl.create(:daily_ration, sprint: _sprint, user: current_user)
      get "/api/v1/sprints/#{_sprint.id}/rations"
      expect(response.status).to eq 200
      expect(response.body).to have_node(:title).with("Kartoshka")
    end
  end
  context 'Daily Menus' do
    it 'GET "/api/v1/dailymenus/" returns daily menus' do
       log_in
       create_sprint
       _category    = FactoryGirl.create(:category)
       _dish  = FactoryGirl.create(:meal, category: _category)
       _daily_menu = FactoryGirl.create(:daily_menu, dish_ids: [_dish.id], day_number: 7)
       get '/api/v1/dailymenus/'
       expect(response.status).to eq 200
       expect(response.body).to have_node(:id).with(_dish.id)
       expect(response.body).to have_node(:day_number).with(7)
    end

    it 'GET "/api/v1/dailymenus/" returns 403 Forbidden when user cannot create new rations' do
      current_user = FactoryGirl.create(:user, email:"test@test.test", name:"test", password:"12345678", password_confirmation: "12345678")
      _user = {email:"test@test.test", password:"12345678"}
      post '/api/v1/sessions/sign_in', _user.to_json,'CONTENT_TYPE' => 'application/json'
      
      _sprint = create_sprint
      daily_ration = FactoryGirl.create(:daily_ration, sprint: _sprint, user: current_user)
      get '/api/v1/dailymenus/'
      expect(response.status).to eq 403
    end
  end
  context 'Daily Rations' do
    context 'Success' do
      it 'POST "/api/v1/daily_ration/" creates new ration' do

        log_in
        create_sprint
        _category    = FactoryGirl.create(:category)
        _dish  = FactoryGirl.create(:meal, category: _category)
        _dish_second  = FactoryGirl.create(:meal, category: _category)
        _daily_menu = FactoryGirl.create(:daily_menu, dish_ids: [_dish.id, _dish_second.id])
        jsondata = 
        {
          "request"=> [{
          "dish_id" => "#{_dish.id}", 
          "quantity"=> 1, 
          "day_id"=> "#{_daily_menu.id}"
          }]
        }
        stringdata = ActiveSupport::JSON.encode(jsondata)
        jsondata = { :data => stringdata }
        post '/api/v1/daily_ration/', jsondata.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq 201
      end
    end
    context 'Fail' do
      it 'POST "/api/v1/daily_ration/" with hacked parameters returns 404' do

        log_in
        create_sprint
        _category    = FactoryGirl.create(:category)
        _dish  = FactoryGirl.create(:meal, category: _category)
        _dish_second  = FactoryGirl.create(:meal, category: _category)
        _daily_menu = FactoryGirl.create(:daily_menu, dish_ids: [_dish.id, _dish_second.id])
        jsondata = 
        {
          "request"=> [{
          "dish_id" => "#{_dish.id}", 
          "quantity"=> 10000, 
          "day_id"=> "#{_daily_menu.id}"
          },{
          "dish_id" => "#{_dish.id}", 
          "quantity"=> 1, 
          "day_id"=> "#{_daily_menu.id}"
          },{
          "dish_id" => "#{_dish.id}", 
          "quantity"=> 1, 
          "day_id"=> "#{_daily_menu.id}"
          }]
        }
        stringdata = ActiveSupport::JSON.encode(jsondata)
        jsondata = { :data => stringdata }
        post '/api/v1/daily_ration/', jsondata.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(response.status).to eq 404
      end
    end
  end
end

# describe 'Daily Ration', :type => :request do
#     let(:log_in) {FactoryGirl.create(:user, email:"test@test.test", name:"test", password:"12345678", password_confirmation: "12345678")
#                 _user = {email:"test@test.test", password:"12345678"}
#                 post '/api/v1/sessions/sign_in', _user.to_json,'CONTENT_TYPE' => 'application/json'}
#     let(:create_sprint) { FactoryGirl.create(:sprint, title: "Test sprint", aasm_state: 'started') }
    
# end