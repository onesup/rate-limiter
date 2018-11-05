module Api
  module V1
    class UsersController < ApplicationController
    	include RateLimit
      def index
        users = User.all
      	if res = reach_max_request?(request.remote_ip)
        	render json: { message: "You have fired too many requests. Please wait for #{res} seconds", status: 429	}
        else
        	render json: users, status: :ok
        end
      end
    end
  end
end



