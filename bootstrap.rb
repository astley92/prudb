def setup_bootstrap
  run("yarn add bootstrap")
  run("yarn add @popperjs/core")

  application_layout_file = Dir["app/views/layouts/application.html.erb"].first
  stylesheet_link_code = "<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>"
  stylesheet_pack_code = "\n\s\s\s\s<%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>"
  in_root {
    insert_into_file(application_layout_file, stylesheet_pack_code, after: stylesheet_link_code)
  }

  file('app/javascript/stylesheets/application.scss', '@import "bootstrap";')

  application_js_file = Dir["app/javascript/packs/application.js"].first
  application_js_indicator = 'import "channels"'
  application_js_code = <<-CODE

import "bootstrap"
import "../stylesheets/application"
CODE
  in_root {
    insert_into_file(application_js_file, application_js_code, after: application_js_indicator)
  }

  file('app/javascript/stylesheets/application.scss', '@import "bootstrap";')
end
