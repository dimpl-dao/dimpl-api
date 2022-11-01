module V1
  module Defaults
    extend ActiveSupport::Concern
    included do
      version 'v1', using: :path
      default_format :json
      format :json

      helpers do
        def logger
          Rails.logger
        end
      end

    end
  end
end