module KlaytnSocket
    module Escrow
        CONTRACT_ADDRESS = ESCROW_ADDRESS
        class Commiter < ApplicationService
            def initialize(event)
                @event = event
            end
            def call
                case @event[:topics][0]
                when ABI::DIMPL_ESCROW[:"ListingCreated(uint256,address,uint256,uint256,uint128,uint128)"][:topic]
                    ListingCreatedHandler.call(@event)
                end
            end
        end
    end
end