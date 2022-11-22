module Cursor
    class Encoder < ApplicationService
        def initialize(params)
            @params = params
        end
        def call
            check_params
            jwt = Jwt::Encoder.call(@params)
            return jwt.split(".")[1]
        end
        private
        def check_params
            ActionController::Parameters.new(@params).require([:last_value, :last_id])
        end
    end
end