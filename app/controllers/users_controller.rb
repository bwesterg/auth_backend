class UsersController < ApplicationController

    skip_before_action :authenticate, only: [:create, :login]

    def index
        @users = User.all 
        render json: @users, status: :ok
    end

    def create
        @user = User.create user_params
        render json: @user, status: :created
    end

    def login
        @user = User.find_by username: params[:user][:username]

        if !@user
            render json: { error: 'Invalid username and/or password' }, status: :unauthorized
        else
            #authenticate is a bcrypt method
            if !@user.authenticate params[:user][:password]
                render json: { error: 'Invalid username and/or password' }, status: :unauthorized
            else
                payload = { user_id: @user.id }
                secret = '1234abcd'
                @token = JWT.encode payload, secret
                render json: { token: @token }, status: :ok
            end
            
        end
    end

    private 

    def user_params
        params.require(:user).permit(:username, :password)
    end
end
