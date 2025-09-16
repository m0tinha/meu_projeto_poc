PRIVATE_KEY = OpenSSL::PKey::RSA.new(
  File.read(Rails.root.join("config/keys/rsa_private.pem"))
)

PUBLIC_KEY = OpenSSL::PKey::RSA.new(
  File.read(Rails.root.join("config/keys/rsa_public.pem"))
)
