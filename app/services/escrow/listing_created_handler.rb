module Escrow
    class ListingCreatedHandler < ApplicationService
        def initialize(event)
            @event = event
        end
        def get_input_types
            return ABI::DIMPL_ESCROW[:"ListingCreated(uint256,address,uint256,uint256,uint128,uint128)"][:inputs].map{|inputs| inputs[:type]}
        end
        def call
            (hash, address, deposit, price, remonstrable_block_interval, id) = Eth::Abi.decode(get_input_types, @event[:data])
            address = address.downcase[2..-1]
            listing_id = IntToUuidConverter.call(id)
            listing = Listing.find_by(id: listing_id)
            user = User.find_by(klaytn_address: address)
            unless user
                user = User.create!({klaytn_address: address})
            end
            if listing
                listing.update!({status: Listing::Status::PAID, hash_id: hash, deposit: deposit, remonstrable_block_interval: remonstrable_block_interval, price: price}) if listing.user_id == user.id
            else
                listing = Listing.new({status: Listing::Status::PAID, hash_id: hash, user_id: user.id, deposit: deposit, remonstrable_block_interval: remonstrable_block_interval, price: price})
                listing.id = listing_id
                listing.save
            end
        end
    end
end