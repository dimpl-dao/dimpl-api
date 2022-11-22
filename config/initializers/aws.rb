CDN_HOST = ENV['STORAGE_CDN_HOST']
Aws.config.update({
  region: ENV['STORAGE_AWS_REGION'],
  credentials: Aws::Credentials.new(ENV['STORAGE_ACCESS_KEY_ID'],  ENV['STORAGE_SECRET_ACCESS_KEY']),
})