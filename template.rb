require_relative('file_loader.rb')

setup_gems
setup_postgres
set_uuid_primary_key
set_routes
set_flash_alerts
setup_devise
setup_bootstrap
rails_command("db:migrate")

after_bundle do
  git_inital_commit
end

