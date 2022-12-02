CDN_HOST = ENV['STORAGE_CDN_HOST']
Aws.config.update({
  region: ENV['STORAGE_AWS_REGION'],
  credentials: Aws::Credentials.new(ENV['STORAGE_ACCESS_KEY_ID'],  ENV['STORAGE_SECRET_ACCESS_KEY']),
})
private_key_file = Rails.root.join("config", "keys", "private_key.pem")
unless File.exists?(private_key_file)
  bucket = Aws::S3::Bucket.new('dimpl-keys')
  object = bucket.object('private_key.pem')
  object.download_file(private_key_file)
end
RSA_PRIVATE = OpenSSL::PKey::RSA.new File.read(private_key_file)