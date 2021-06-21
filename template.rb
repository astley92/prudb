def apply_template!
  say("Using template to setup gems")
  gsub_file("Gemfile", /^gem\s+["']sqlite3["'].*$/,'')
  gem('devise')
  gem('pg')
  gem_group(:development, :test) do
    gem("rspec-rails")
  end
  run("bundle install")

  say("Using template to setup postgresql")
  remove_file('config/database.yml')
  file('config/database.yml', postgres_database_code)

  say("Using template to set UUID as Primary key type")
  generate(:migration, "enable_uuid")
  custom_insert_into_file(
    "db/migrate/*enable_uuid.rb",
    enable_uuid_code,
    "change",
    next_line: true,
  )
  custom_insert_into_file(
    "app/models/application_record.rb",
    application_model_code,
    "self.abstract_class = true",
    next_line: true,
  )
  rails_command("db:create")
  file('config/initializers/generators.rb', generators_code)

  say("Using template to setup flash alerts")
  custom_insert_into_file(
    "app/views/layouts/application.html.erb",
    "\s\s\s\s<%= render 'layouts/alerts' %>",
    "<body>",
    next_line: true,
  )
  file('app/views/layouts/_alerts.html.erb', flash_alert_code)

  say("Using template to setup Devise")
  generate("devise:install")
  generate("devise:views")
  custom_insert_into_file(
    "config/environments/development.rb",
    default_mailer_code,
    "Rails.application.configure do",
    next_line: true,
  )

  say("Using template to setup Bootstrap 5")
  run("yarn add bootstrap")
  run("yarn add @popperjs/core")
  custom_insert_into_file(
    "app/views/layouts/application.html.erb",
    stylesheet_pack_code,
    stylesheet_pack_code_indicator,
    next_line: true,
  )
  file('app/javascript/stylesheets/application.scss', '@import "bootstrap";')
  custom_insert_into_file(
    "app/javascript/packs/application.js",
    application_js_code,
    'import "channels"',
    next_line: true,
  )
  file('app/javascript/stylesheets/application.scss', '@import "bootstrap";')

  say("Using template to setup RSpec")
  rails_command("generate rspec:install")
  run("rm -rf test")
  custom_insert_into_file(
    "config/initializers/generators.rb",
    "\s\sg.test_framework :rspec",
    "g.orm :active_record, primary_key_type: :uuid",
    next_line: true,
  )

  say("Migrating and commiting to finalize template setup")
  rails_command("db:migrate")
  after_bundle do
    git(:init)
    git(add: ".")
    git(commit: %Q{ -m 'Initial commit' })
  end
end

def custom_create_file(file, code: nil)
  code = code.nil? ? "" : code
  file(file, code)
end

def custom_insert_into_file(filepath, code, indicator, next_line: false)
  # TODO: Implement indent_level kwarg
  file = Dir[filepath].first
  code = next_line ? "\n#{code}" : code
  in_root {
    insert_into_file(file, code, after: indicator)
  }
end

def default_mailer_code
  <<-CODE
  # Setting mailer default url as required by devise.
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
CODE
end

def application_js_code
  <<-CODE
import "bootstrap"
import "../stylesheets/application"
CODE
end

def stylesheet_pack_code_indicator
  "<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>"
end

def stylesheet_pack_code
  "\s\s\s\s<%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>"
end

def enable_uuid_code
"\s\s\s\senable_extension 'pgcrypto'"
end

def flash_alert_code
  <<-CODE
<% if flash.any? %>
  <% flash.each do |type, msg|  %>
    <% if type == 'alert' %>
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% elsif type == 'notice' %>
      <div class="alert alert-primary alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% elsif type == 'errors' %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% elsif type == 'success' %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% else %>
      <div class="alert alert-primary alert-dismissible fade show" role="alert">
        <strong>This type of alert is not explicitly handled. You should update app/views/layouts/_alerts.html.erb</strong>
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% end %>
  <% end %>
<% end %>
CODE
end

def generators_code
  <<-CODE
Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
end
CODE
end

def application_model_code
  <<-CODE.chomp

  # Sort records by date of creation instead of primary key
  self.implicit_order_column = :created_at
CODE
end

def postgres_database_code
  <<-CODE
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: #{@app_name}_development

  # The specified database role being used to connect to postgres.
  # To create additional roles in postgres see `$ createuser --help`.
  # When left blank, postgres will use the default role. This is
  # the same name as the operating system user that initialized the database.
  # username: foo

  # The password associated with the postgres role (username).
  # password:

  # Connect on a TCP socket. Omitted by default since the client uses a
  # domain socket that doesn't need configuration. Windows does not have
  # domain sockets, so uncomment these lines.
  #host: localhost

  # The TCP port the server listens on. Defaults to 5432.
  # If your server runs on a different port number, change accordingly.
  #port: 5432

  # Schema search path. The server defaults to $user,public
  #schema_search_path: myapp,sharedapp,public

  # Minimum log levels, in increasing order:
  #   debug5, debug4, debug3, debug2, debug1,
  #   log, notice, warning, error, fatal, and panic
  # Defaults to warning.
  #min_messages: notice

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: #{@app_name}_test

# As with config/secrets.yml, you never want to store sensitive information,
# like your database password, in your source code. If your source code is
# ever seen by anyone, they now have access to your database.
#
# Instead, provide the password as a unix environment variable when you boot
# the app. Read http://guides.rubyonrails.org/configuring.html#configuring-a-database
# for a full rundown on how to provide these environment variables in a
# production deployment.
#
# On Heroku and other platform providers, you may have a full connection URL
# available as an environment variable. For example:
#
#   DATABASE_URL="postgres://myuser:mypass@localhost/somedatabase"
#
# You can use this database configuration with:
#
#   production:
#     url: <%= ENV['DATABASE_URL'] %>
#
production:
  <<: *default
  database: #{@app_name}_production
  username: #{@app_name}
CODE
end

apply_template!
