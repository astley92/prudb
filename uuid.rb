def enable_uuid_code
"\n\s\s\s\senable_extension 'pgcrypto'"
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

def set_uuid_primary_key
  migration_name = "enable_uuid"
  generate(:migration, migration_name)
  enable_uuid_migration_file = Dir["db/migrate/*#{migration_name}.rb"].first
  application_model_file = Dir["app/models/application_record.rb"].first

  in_root {
    insert_into_file(enable_uuid_migration_file, enable_uuid_code,  after: "change")
  }

  in_root {
    insert_into_file(application_model_file, application_model_code, after: "self.abstract_class = true")
  }

  rails_command("db:create")
  file('config/initializers/generators.rb', generators_code)
end
