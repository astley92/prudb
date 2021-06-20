require_relative('file_loader.rb')

setup_gems
setup_postgres
set_uuid_primary_key
set_routes
set_flash_alerts
setup_devise

after_bundle do
  git_inital_commit
end
