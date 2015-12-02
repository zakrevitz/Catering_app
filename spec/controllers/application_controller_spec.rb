require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  
  context 'Admin log in' do
    login_admin

    it "should have a current_user" do
     expect(subject.current_user).not_to be_nil
    end

    it "should be admin" do
      expect(subject.current_admin_user).not_to be_nil
    end
  end

  context 'User log in' do
    login_user
    it "should have a current_user" do
     expect(subject.current_user).not_to be_nil
    end

    it "should not be admin" do
      expect(subject.current_admin_user).to be_nil
    end
  end
end