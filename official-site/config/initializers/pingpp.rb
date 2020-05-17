require "pingpp"

Pingpp.api_key = ENV.fetch("PINGPP_KEY")
Pingpp.private_key_path = Rails.root.to_s + "/config/pingpp/rsa_private_key.pem"
