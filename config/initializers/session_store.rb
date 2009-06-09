# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_transmission_session',
  :secret      => 'e6888f94cc333d52e28e11af3da3ca32b0cdba785bcbc402bd7c424157c456978176fe19ac58120e38b6e463300bf7aa41df2e1d7947acd3f1c2f6bbce409645'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
