module Api
  module V1
    class UsersController < ApplicationController
    	include RateLimit
      def index
        users = User.all
      	if res = reach_max_request?(request.remote_ip)
        	render json: { message: "Rate limit exceeded. Try again in #{res} seconds" }, status: :too_many_requests
        else
        	render json: users, status: :ok
        end
      end
    end
  end
end



