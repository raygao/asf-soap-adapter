# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_asf-soap-adapter-rails-app_session',
  :secret      => '36feb8424fe91f7593f9a203c892c9f909dfc6009a99ac4e3e64b56c2e7508fe41fa446f1f3a7a6815c2aba76d319974e0c3e522fb50acc5789c521dc23578f5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
