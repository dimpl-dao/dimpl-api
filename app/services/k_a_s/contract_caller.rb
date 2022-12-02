module KAS
    class ContractCaller < ApplicationService
        ROOT_DOMAIN = 'https://node-api.klaytnapi.com/v1/klaytn'

        def initialize(function_abi, options)
            @function_abi = function_abi
            @inputs = options[:inputs]
            @contract = options[:contract]
        end

        def call
            input_types = @function_abi[:inputs].map{|input| input[:type]}
            output_types = @function_abi[:outputs].map{|output| output[:type]}
            encoded_params = Eth::Util.bin_to_hex(Eth::Abi.encode(input_types, @inputs))
            response = klay_call(to: @contract, data: @function_abi[:sighash] + encoded_params)
            return Eth::Abi.decode(output_types, response["result"])
        end

        def klay_call(
            data: ,
            from: KAS::CONFIG[:admin_address], 
            value: "0x0", 
            to: ,
            gas: "0x0")
            url = ROOT_DOMAIN
            external_api_service = ExternalApiService.new(url, KAS::CONFIG[:access_key_id], KAS::CONFIG[:secret_access_key])
            body = {
                jsonrpc: "2.0",
                method: "klay_call",
                params: [
                    {
                        from: from,
                        value: value,
                        to: to,
                        data: data,
                        gas: gas
                    },
                    "latest"
                ],
                id: 1
            }
            external_api_service.call(HTTP_METHOD::POST, body, {"x-chain-id": KAS::Chain::DEFAULT})
        end
    end
end