module Escrow
    class Commiter < ApplicationService
        def initialize(event)
            @event = event
        end
        def call
            case @event[:topics][0]
            when ABI::DIMPL_ESCROW[:"ListingCreated(uint256,address,uint256,uint256,uint128,uint128)"][:topic]
                ListingCreatedHandler.call(@event)
            when ABI::DIMPL_ESCROW[:"BidCreated(uint256,address,uint256,uint256,uint128,uint128)"][:topic]
                BidCreatedHandler.call(@event)
            when ABI::DIMPL_ESCROW[:"BidSelected(uint256)"][:topic]
                BidSelectedHandler.call(@event)
            end
        end
    end
end