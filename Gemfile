source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "pg"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# Authentication and Authorization
gem "devise"
gem "devise-jwt"
gem "pundit"

# GraphQL
gem "graphql"
gem "graphiql-rails", group: :development

# Rack Middleware
gem "rack-attack"
gem "rack-cors"

# Environment Variables
gem "dotenv-rails"

# Asset Management
gem "propshaft"
gem "sprockets-rails"

# AWS SDK
gem "aws-sdk-s3", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
