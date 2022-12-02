module V1
    class DeliveryAddressApi < Grape::API
        resource :delivery_address do
            params do
                requires :address_ko, type: String
                requires :address_en, type: String
                requires :zonecode, type: String
                requires :specifics, type: String
                requires :name, type: String
            end
            post do
                authenticate!
                delivery_address = DeliveryAddress.create(
                    address_ko: params[:address_ko], 
                    address_en: params[:address_en],
                    zonecode: params[:zonecode],
                    specifics: params[:specifics],
                    name: params[:name],
                    user_id: current_user.id,
                )
                return {
                    success: true,
                    delivery_address: delivery_address
                }
            end

            params do
                requires :id, type: String
            end
            get do
                delivery_address = DeliveryAddress.find_by(params)
                unless delivery_address 
                    return {
                        success: false,
                    }
                end
                return {
                    success: true,
                    delivery_address: delivery_address
                }
            end

            params do
                optional :limit, type: Integer, values: { proc: ->(v) { v.positive? && v <= 30 } }, default: 20
                optional :cursor, type: String
            end
            get :list do
                authenticate!
                feed = Feed::DeliveryAddressGetter.call({user_id: current_user.id})
                return {
                    success: true,
                    delivery_addresses: feed[:delivery_addresses],
                    cursor: feed[:cursor]
                }
            end
        end
    end
end