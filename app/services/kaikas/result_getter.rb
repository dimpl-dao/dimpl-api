module Kaikas
    class ResultGetter < ApplicationService
        def initialize(request_key)
            url = Kaikas.api_url(RESULT, request_key: request_key)
            @kaikas_api = ExternalApiService.new(url)
        end
        def call
            result = @kaikas_api.call(HTTP_METHOD::GET, {})
            if result[:status] == Kaikas::ResultStatus::COMPLETED
                return result[:result]
            end
            return nil
        end    
    end
end