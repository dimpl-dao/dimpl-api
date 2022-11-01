module V1
    class UserApi < Grape::API
        resource :user do

            params do
                optional :account, type: String, regexp: /^0x[a-f0-9]{40}$/
                optional :signature, type: String
            end
            get do
                if params[:signature] && params[:account]
                    account = params[:account].downcase
                    user = User.find(account)
                    verified = AuthHelper::Nonce.verify(nonce: user.nonce, signature: params[:signature], address: account)
                    if verified
                        return {
                            success: true, 
                            user: user,
                            jwt: user.create_jwt
                        }
                    end
                end
                authenticate!
                return {
                    success: true, 
                    user: current_user,
                    jwt: current_user.create_jwt,
                }
            end

            params do
                optional :account, type: String, regexp: /^0x[a-f0-9]{40}$/
            end
            put do
                nonce_decoder = NonceDecoderService.new
                user = User.find_or_create_by(account: current_user&.account || params[:account].downcase)
                user.nonce = nonce_decoder.nonce
                user.save
                return {
                    success: true, 
                    message: message_from_nonce,
                    user: user,
                }
            end

        end
    end
end