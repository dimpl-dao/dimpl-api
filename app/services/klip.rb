module Klip
    extend self

    @klip_api_root = 'https://a2a-api.klipwallet.com/'
    @klip_api_qr_root = 'https://klipwallet.com/'

    PREPARE = 0
    REQUEST = 1
    RESULT = 2
    GET_CARD_INFO = 3

    module ResultStatus
        PREPARED = "prepared"
        PREPARING = "preparing"
        CANCELLED = "canceled"
        COMPLETED = "completed"
    end

    class KlipApiRequestTypeError < StandardError
        def message
            "Invalid Request Type"
        end
    end

    def api_url(type, request_key: '')
        case type
        when PREPARE
            return @klip_api_root + 'v2/a2a/prepare'
        when REQUEST
            return @klip_api_qr_root + '?target=/a2a?request_key=' + request_key
        when RESULT 
            return @klip_api_root + 'v2/a2a/result?request_key=' + request_key
        when GET_CARD_INFO
            return @klip_api_root + 'v2/a2a/cards?cursor=' + request_key
        else
            raise KlipApiRequestTypeError
        end
    end

end