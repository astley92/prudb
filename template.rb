require_relative('gems.rb')
require_relative('postgres.rb')
require_relative('uuid.rb')
require_relative('devise.rb')
require_relative('routes.rb')
require_relative('flash.rb')
require_relative('environments/development.rb')
require('pry')

gems_setup
postgres_setup
uuid_setup
set_routes
set_flash
devise_setup

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
