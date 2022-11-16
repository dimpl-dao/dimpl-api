class ExternalApiService

    class ExternalApiMethodError < StandardError; end

    class ExternalApiRequestError < StandardError; end

    def initialize(url, username=nil, password=nil, log=false)
        @url = url
        @log = log
        @conn = Faraday.new(url: url) do |builder|
            builder.request(:url_encoded)
            builder.request(:authorization, :basic, username, password) if username && password
            builder.response(:logger) if log
            builder.adapter(Faraday.default_adapter)
        end
    end

    def call(method=HTTP_METHOD::GET, body = {}, headers = {})
        case method 
        when HTTP_METHOD::GET
            return get(headers)
        when HTTP_METHOD::POST
            return post(body, headers)
        else
            raise ExternalApiMethodError
        end
    end

    def get(headers= {}) 
        response = @conn.get do |req|
            req.headers['Content-Type'] = 'application/json'
            headers.to_a.each do |header|
                req.headers[header[0].to_s] = header[1].to_s
            end
        end
        return evaluate_response(response)
    end

    def post(body = {}, headers= [])
        response = @conn.post do |req|
            req.headers['Content-Type'] = 'application/json'
            headers.to_a.each do |header|
                req.headers[header[0].to_s] = header[1].to_s
            end
            req.body = body.to_json
        end
        return evaluate_response(response)
    end

    def evaluate_response(response)
        if response.success?
            return parse_response(response)
        else
            raise ExternalApiRequestError
        end
    end

    def parse_response(response)
        return nil if response.body.blank?
        return ActiveSupport::JSON.decode(response.body).with_indifferent_access
    end
    
end