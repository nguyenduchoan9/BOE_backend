require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user){ create(:user) }

  before(:all) do
    Role.create(name: 'user')
    # FactoryGirl.create(:role)
  end

  before(:each) do
    set_version('v1')
  end

  describe 'Post #create' do
    it 'error missing email' do
      post :create, params: {}, format: :json

      expect(json_response['error']['message']).to have_key('email')
      expect(json_response['error']['status']).to eq(422)
    end

    it 'error email exist' do
      user
      post :create, params: {email: user.email}, format: :json

      expect(json_response['error']['message']).to have_key('email')
      expect(json_response['error']['message']['email']).to include('taken')
    end

    it 'error password too short' do
      post :create, params: {email: 'useremail@gmail.com', password: '123'}, format: :json

      expect(json_response['error']['message']).to have_key('password')
    end

    it 'error password confirm not match' do
      post :create, params: {email: 'user.email@gmail.com', password: '123456', password_confirmation: '1234567'}, format: :json

      expect(json_response['error']['message']).to have_key('password_confirmation')
    end

    it 'error first_name require' do
      post :create, params: {email: 'useremail@gmail.com', password: '123'}, format: :json

      expect(json_response['error']['message']).to have_key('password')
    end

    it 'create success' do
      expect {
        post :create, params: {first_name: 'hoang', last_name: 'nguyen', email: 'nguyenhoang@gmail.com',
                               password: '12345678', password_confirmation: '12345678'}, format: :json
      }.to change(User, :count).by(1)

      expect(json_response['email']).to eq('nguyenhoang@gmail.com')
      expect(json_response['provider']).to eq('email')
    end
  end
end
