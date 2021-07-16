class ApplicationController < ActionController::API

    before_action :authenticate

    def authenticate
        auth_header = request.headers[:Authorization]

        if !auth_header
            render json: { error: 'Auth bearer token header must be present' }, status: :forbidden
        else
            token = auth_header.split(' ')[1]
            secret = '1234abcd'
            begin
                JWT.decode token, secret
            rescue
                render json: { error: 'Bad token'}, status: :forbidden
            end  
        end
    end

end