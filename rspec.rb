def rspec_generator_code
  "\n\s\sg.test_framework :rspec"
end

def setup_rspec
  rails_command("generate rspec:install")
  run("rm -rf test")

  generators_file = Dir["config/initializers/generators.rb"].first

  in_root {
    insert_into_file(generators_file, rspec_generator_code,  after: "g.orm :active_record, primary_key_type: :uuid")
  }
end
