# kindly generated by appropriated Rails generator
Mailjet.configure do |config|
  config.api_key = '1afca57d88b9441c16d70b0ef2d0eae0'
  config.secret_key = '987e2a6174ab1630f4c0f069bae52ce1'
  config.default_from = 'yorumlaabusiness@gmail.com'
  # Mailjet API v3.1 is at the moment limited to Send API.
  # We’ve not set the version to it directly since there is no other endpoint in that version.
  # We recommend you create a dedicated instance of the wrapper set with it to send your emails.
  # If you're only using the gem to send emails, then you can safely set it to this version.
  # Otherwise, you can remove the dedicated line into config/initializers/mailjet.rb.
  config.api_version = 'v3.1'

end
