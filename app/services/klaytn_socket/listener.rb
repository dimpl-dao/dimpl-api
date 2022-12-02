module KlaytnSocket
    class Listener < ApplicationService

        attr_accessor :ws

        def initialize
        end

        def call
          EM.run{
            @ws = Faye::WebSocket::Client.new("wss://public-node-api.klaytnapi.com/v1/cypress/ws", [], tls: {
              verify_peer: false
            })
            @ws.on :open do |event|
              @ws.send({
                  "jsonrpc":"2.0", 
                  "id": 1, 
                  "method": "klay_subscribe", 
                  "params": ["logs", {"address": [
                    Governor::CONTRACT_ADDRESS, 
                    Escrow::CONTRACT_ADDRESS, 
                    GovernanceToken::CONTRACT_ADDRESS
                  ]}]
                }.to_json)
            end
            @ws.on :message do |event|
              begin
                result = JSON.parse(event.data).with_indifferent_access[:params][:result].with_indifferent_access
                case result[:address] 
                when Escrow::CONTRACT_ADDRESS
                  Escrow::Commiter.call(result)
                end
              rescue
              end
            end
            @ws.on :close do |event|
              call
            end 
          }
          return @ws
        end 

    end
end