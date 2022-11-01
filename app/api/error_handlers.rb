module BetterWorld
    module ErrorHandlers
        extend ActiveSupport::Concern
    
        included do
            rescue_from ActiveRecord::RecordNotFound do |e|
                error!({ error_code: 404, message: e.message, with: Entities::ApiError }, 404)
            end
    
            rescue_from NoMethodError do |e|
                error!({
                        error_code: 400,
                        message: "Wrong Request: #{e}}", with: Entities::ApiError }, 400)
            end
    
            rescue_from :all do |e|
                error!({
                    error_code: 500,
                    message: "Internal server error: #{e.to_s}", with: Entities::ApiError }, 500)
            end
    
            rescue_from Grape::Exceptions::ValidationErrors do |e|
                error!(e, 400)
            end
        end
    end
end