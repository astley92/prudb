def setup_gems
  gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''

  gem 'devise'
  gem 'pg'

  gem_group :development, :test do
    gem "rspec-rails"
  end
end
