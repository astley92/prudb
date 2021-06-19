require_relative('gems.rb')
require_relative('postgres.rb')
require_relative('uuid.rb')
require('pry')

gems_setup
postgres_setup
uuid_setup

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
