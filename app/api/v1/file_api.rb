module V1
    class FileApi < Grape::API
        resource :file do

            params do
                requires :file, type: Hash do
                    requires :filename, type: String
                    requires :byte_size, type: Integer
                    requires :checksum, type: String
                    requires :content_type, type: String, values: ["image/png", "image/jpeg", "image/gif"]
                    optional :metadata, type: Hash
                end
                requires :attached_record, type: String, values: [Listing.to_s.underscore]
            end
            post :image do
                authenticate!
                key = "image/#{params[:attached_record]}/"
                file = ImagePresignedUrlCreator.call(params, {key: key})
                p file

                return {
                    success: true,
                    file: file,
                }
            end
            
        end
    end
end