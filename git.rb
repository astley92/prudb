def git_inital_commit
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
