module V1
    module CurrentUserHelper
        extend Grape::DSL::Helpers::BaseHelper

        def current_user
            return @current_user if @current_user
            if request.headers['Authorization']
                jwt = request.headers['Authorization'].split(' ').last
                @current_user = Auth::Authenticator.call(jwt)
                return @current_user
            end
        end

        def authenticate!
            error!('Unauthorized', 403) unless current_user
        end
    end
end