module Klip
    class ResultGetter < ApplicationService
        def initialize(request_key)
            url = Klip.api_url(RESULT, request_key: request_key)
            @klip_api = ExternalApiService.new(url)
        end
        def call
            result = @klip_api.call(HTTP_METHOD::GET, {})
            if result[:status] == Klip::ResultStatus::COMPLETED
                return result[:result]
            end
            return nil
        end    
    end
end