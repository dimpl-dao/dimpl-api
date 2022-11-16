path = Rails.root.join("config", "keys", "private_key.pem")
RSA_PRIVATE = OpenSSL::PKey::RSA.new File.read(path)
RSA_PUBLIC = OpenSSL::PKey::RSA.new File.read(path)