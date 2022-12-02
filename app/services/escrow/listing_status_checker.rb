module Escrow
    class ListingStatusChecker < ApplicationService
        def initialize(listing)
            @listing = listing
            @user = @listing.user
        end

        def call
            (locked, address, deposit, price, remonstrable_block_interval, id) = KAS::ContractCaller.call(
                ABI::DIMPL_ESCROW[:"getListing(address,uint256,uint256,uint128,uint128)"], 
                {
                    inputs: ["0x#{@user.klaytn_address}", @listing.deposit, @listing.price, UuidToIntConverter.call(@listing.id), @listing.remonstrable_block_interval], 
                    contract: Escrow::CONTRACT_ADDRESS
                }
            )
            return address == @user.klaytn_address
        end
    end
end