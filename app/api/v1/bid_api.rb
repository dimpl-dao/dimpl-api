module V1
    class BidApi < Grape::API
        resource :bid do
            params do
                requires :listing_id, type: String
                requires :deposit, type: Integer
                requires :delivery_address_id, type: String
                optional :description, type: String
            end
            post do
                authenticate!
                bid = Bid.create!(
                    listing_id: params[:listing_id], 
                    delivery_address_id: params[:delivery_address_id],
                    description: params[:description],
                    deposit: params[:deposit],
                    user_id: current_user.id,
                    status: Bid::Status::CREATED
                )
                return {
                    success: true,
                    bid: bid
                }
            end

            get :abi do
                return {
                    success: true,
                    contract_address: Escrow::CONTRACT_ADDRESS,
                    create: ABI::DIMPL_ESCROW[:"bid(uint256,uint128)"],
                }
            end

            params do
                requires :id, type: String
            end
            get do
                bid = Bid.find_by(params)
                unless bid 
                    return {
                        success: false,
                    }
                end
                return {
                    success: true,
                    bid: bid.as_json({
                        include: [
                            {
                                listing: {
                                    methods: [
                                        :image_uri,
                                    ]
                                }
                            },
                            :user,
                            :delivery_address
                        ],
                    }),
                }
            end

            params do
                requires :status, type: Integer, values: [Bid::Status::CREATED, Bid::Status::PAID]
                optional :limit, type: Integer, values: { proc: ->(v) { v.positive? && v <= 30 } }, default: 15
                optional :cursor, type: String
                optional :klaytn_address, type: String, regexp: /^[a-f0-9]{40}$/
            end
            get :list do
                user = if params[:klaytn_address] 
                    User.find_by(klaytn_address: params[:klaytn_address] )
                else 
                    current_user
                end
                return {
                    success: false
                } unless user
                feed = Feed::BidGetter.call({status: params[:status], user_id: user.id}, {limit: params[:limit], cursor: params[:cursor]})
                return {
                    success: true,
                    bids: feed[:bids],
                    cursor: feed[:cursor],
                }
            end

        end
    end
end