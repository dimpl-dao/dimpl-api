module V1
    class UserApi < Grape::API
        resource :user do

            get do
                authenticate!
                return {
                    success: true, 
                    user: current_user.profile_dto,
                    jwt: Auth::JwtCreator.call(current_user),
                }
            end

            params do
                requires :klaytn_address, type: String, regexp: /^0x[a-fA-F0-9]{40}$/
                requires :request_key, type: String
                requires :type, type: String, values: ['klip', 'kaikas']
            end
            put do
                klaytn_address = params[:klaytn_address].downcase
                result = if params[:type] == 'klip'
                    Klip::ResultGetter.call(params[:request_key])
                else
                    Kaikas::ResultGetter.call(params[:request_key])
                end
                if result && result[:klaytn_address].downcase == klaytn_address
                    user = User.find_or_create_by!(klaytn_address: klaytn_address[2..-1])
                    jwt = Auth::JwtCreator.call(user)
                    return {
                        success: true,
                        user: user.profile_dto,
                        jwt: jwt
                    }
                end
                return {
                    success: false
                }
                
            end

        end
    end
end