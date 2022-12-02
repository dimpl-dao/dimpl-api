module KAS
    
    CONFIG = Rails.application.config_for(:kas)
    
    module Chain
        CYPRESS = 8217
        BAOBAB = 1001
        DEFAULT = CYPRESS
    end

end