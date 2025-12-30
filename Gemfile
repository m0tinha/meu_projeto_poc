source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "sqlite3", ">= 1.4"
gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false
gem 'jwt'
gem 'bcrypt', '~> 3.1.7'
gem 'pg', '~> 1.6'




group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end


