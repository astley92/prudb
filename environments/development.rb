def default_mailer_code
  <<-CODE

  # Setting mailer default url as required by devise.
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
CODE
end

def set_development_environment
  development_environment_file = Dir["config/environments/development.rb"].first

  in_root {
    insert_into_file(development_environment_file,
      default_mailer_code,
      after: "Rails.application.configure do"
    )
  }
end
