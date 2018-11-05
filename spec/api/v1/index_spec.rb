require 'rails_helper'

# RSpec.describe 'API V1 products index', type: :api do
#   before do
#     5.times do |i|
#       User.create(name: "test_#{i}", email:"test_#{i}@gmail.com")
#     end
#   end

#   it 'returns all users with status code ok' do 
#     expect()
#   it { is_expected.to have_http_status(:ok) }
# end


RSpec.describe Api::V1::UsersController do
  before do
    5.times do |i|
      User.create(name: "test_#{i}", email:"test_#{i}@gmail.com")
    end
    $redis.del('counting_127.0.0.1')
    $redis.del('blocked_127.0.0.1')
  end

  after do
    $redis.del('counting_127.0.0.1')
    $redis.del('blocked_127.0.0.1')
  end
  
  describe "GET #index" do
    before do
      $redis.del('counting_127.0.0.1')
      $redis.del('blocked_127.0.0.1')
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
