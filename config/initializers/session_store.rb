# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_VIZ_session',
  :secret      => '9fe243889c43afeeaf3ae3e67827a5093b3156bcf8677b0e19f781218c13f3a23aab720c8c125d32e54ea5c3553e2229f9cf24821c79693dddbb97ed2041dd27'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
