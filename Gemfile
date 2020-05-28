source "https://rubygems.org"

gem "jets", "2.3.16"
gem "dynamoid", "3.5.0"
gem "foreman", "0.87.1"
gem "term-ansicolor", "1.7.1"

# development and test groups are not bundled as part of the deployment
group :development, :test do
  gem 'shotgun', '0.9.2'
  gem 'rack', '2.2.2'
  gem 'puma', '4.3.5'
end

group :test do
  gem 'rspec', '3.9.0' # rspec test group only or we get the "irb: warn: can't alias context from irb_context warning" when starting jets console
end
