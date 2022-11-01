Rails.application.routes.draw do
  mount V1::Base => 'api'
end
