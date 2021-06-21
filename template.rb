def source_paths
  [__dir__]
end

require_relative('file_loader.rb')

setup_gems

run("bundle install")

setup_postgres
set_uuid_primary_key
set_routes
set_flash_alerts
setup_devise
setup_bootstrap
setup_rspec
rails_command("db:migrate")

after_bundle do
  git_inital_commit
end

