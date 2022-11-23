module KlaytnSocket
    module Escrow
        CONTRACT_ADDRESS = "0x3469BB90b5280e7AC2BCA66C3761f8d98F6503b2"
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