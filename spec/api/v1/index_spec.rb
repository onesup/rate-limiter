require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before do
    5.times do |i|
      User.create(name: "test_#{i}", email:"test_#{i}@gmail.com")
    end

    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '1.2.3.4' }

    $redis.del('counting_1.2.3.4')
    $redis.del('blocked_1.2.3.4')
  end

  after do
    $redis.del('counting_1.2.3.4')
    $redis.del('blocked_1.2.3.4')
  end
  
  describe "GET #index" do
    before do
      $redis.del('counting_1.2.3.4')
      $redis.del('blocked_1.2.3.4')
      get '/api/v1/users', xhr: true
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end  


    it 'returns all users' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(5)

      user = json_response[0]
      expect(user["name"]).to eq("test_0")
    end 
  end


  describe "GET #index less or equal to 100 times in 60 minutes" do
    before do      
      100.times do 
        get '/api/v1/users'
      end
    end
    
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end   
  end

  describe "GET #index more than 100 times in 60 minutes" do
    before do
      101.times do 
        get '/api/v1/users'
      end
    end
    
    it "returns http too_many_requests" do
      expect(response).to have_http_status(:too_many_requests)
    end   
  end
end
