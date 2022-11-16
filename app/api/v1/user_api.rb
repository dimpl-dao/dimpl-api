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
                requires :account, type: String, regexp: /^0x[a-fA-F0-9]{40}$/
                requires :request_key, type: String
                requires :type, type: String, values: ['klip', 'kaikas']
            end
            put do
                account = params[:account].downcase
                result = if params[:type] == 'klip'
                    Klip::ResultGetter.call(params[:request_key])
                else
                    Kaikas::ResultGetter.call(params[:request_key])
                end
                if result && result[:klaytn_address].downcase == account
                    user = User.find_or_create_by!(account: account[2..-1])
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