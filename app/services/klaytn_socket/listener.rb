module KlaytnSocket
    class Listener < ApplicationService

        attr_accessor :ws

        def initialize
        end

        def call
          EM.run{
            @ws = Faye::WebSocket::Client.new("wss://public-node-api.klaytnapi.com/v1/baobab/ws", [], tls: {
              verify_peer: false
            })
            @ws.on :open do |event|
              p [:open]
              @ws.send({
                  "jsonrpc":"2.0", 
                  "id": 1, 
                  "method": "klay_subscribe", 
                  "params": ["logs", {"address": [
                    KlaytnSocket::Governor::CONTRACT_ADDRESS, 
                    KlaytnSocket::Escrow::CONTRACT_ADDRESS, 
                    KlaytnSocket::GovernanceToken::CONTRACT_ADDRESS
                  ]}]
                }.to_json)
            end
            @ws.on :message do |event|
              begin
                result = JSON.parse(event.data).with_indifferent_access[:params][:result]
                case result[:address] 
                when KlaytnSocket::Escrow::CONTRACT_ADDRESS
                  KlaytnSocket::Escrow::Commiter.call(result)
                end
              rescue
              end
            end
            @ws.on :close do |event|
              p [:close, event.code, event.reason]
              call
            end 
          }
          return @ws
        end 

    end
end