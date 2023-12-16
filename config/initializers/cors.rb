# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins "example.com"
#
#     resource "*",
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins 'https://rustoff.vercel.app'
    origins 'http://localhost:5173'
    
    resource '*',
      headers: :any,
      expose: ['access-token', 'expiry', 'token-type', 'Authorization'],
      methods: %i[get post put patch delete options head],
      credentials: true
    
  end

  allow do
    origins 'https://checkout.stripe.com'

    resource '*',
      headers: :any,
      methods: [:options],
      credentials: true
  end

  
end



