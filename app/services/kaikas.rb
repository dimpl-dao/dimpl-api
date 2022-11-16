module Kaikas
    extend self

    @kaikas_api_root = 'https://api.kaikas.io/'

    PREPARE = 0
    RESULT = 1

    module ResultStatus
        PREPARED = "prepared"
        PREPARING = "preparing"
        CANCELED = "canceled"
        COMPLETED = "completed"
    end

    class KaikasApiRequestTypeError < StandardError
        def message
            "Invalid Request Type"
        end
    end

    def api_url(type, request_key: '')
        case type
        when PREPARE
            return @kaikas_api_root + 'api/v1/k/prepare/'
        when RESULT 
            return @kaikas_api_root + 'api/v1/k/result/' + request_key
        else
            raise KlipApiRequestTypeError
        end
    end

end