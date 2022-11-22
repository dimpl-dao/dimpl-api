module V1
    class Base < Grape::API
        include V1::Defaults

        format :json
        content_type :json, 'application/json'

        NO_SLASH_URL_PART_REGEX = %r{[^/]+}.freeze

        version 'v1', using: :path

        before do
            header['Access-Control-Allow-Origin'] = '*'
            header['Access-Control-Request-Method'] = '*'
        end

        helpers CurrentUserHelper

        namespace do
            mount UserApi
            mount ListingApi
            mount BidApi
            mount FileApi

            get :ping do
    
                return {
                    data: "pong"
                }
    
            end
        end
    end
end
  