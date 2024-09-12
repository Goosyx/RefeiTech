# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Aqui você pode especificar quais domínios podem acessar sua API. Exemplo: 'https://exemplo.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization'],  # Expose headers se necessário
      max_age: 600
  end
end
