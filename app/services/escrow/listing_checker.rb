module Escrow
    class ListingChecker < ApplicationService
        def initialize(listing)
            @listing = listing
        end
        def call
            (locked, address, deposit, price, bid_hash_id, bid_selected_block, remonstrable_block_interval) = KAS::ContractCaller.call(
                ABI::DIMPL_ESCROW[:"listings(uint256)"], 
                {
                    inputs: [Hasher::Listing.call(@listing)], 
                    contract: Escrow::CONTRACT_ADDRESS
                }
            )
            return (locked, address, deposit, price, bid_hash_id, bid_selected_block, remonstrable_block_interval)
        end
    end
end