require_relative('gems.rb')
require_relative('postgres_setup.rb')

gems_setup
postgres_setup

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
