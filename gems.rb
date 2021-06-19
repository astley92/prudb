def gems_setup
  gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''

  gem 'pg'
end
