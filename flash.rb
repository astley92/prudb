def set_flash_alerts
  # TODO: <%= render 'layouts/alerts' %> in application.html.erb
  application_layout_file = Dir["app/views/layouts/application.html.erb"].first
  flash_layout_code = "\n\s\s\s\s<%= render 'layouts/alerts' %>"
  flash_layout_indicator = "<body>"
  in_root {
    insert_into_file(application_layout_file, flash_layout_code, after: flash_layout_indicator)
  }

  file('app/views/layouts/_alerts.html.erb', <<-CODE)
<% if flash.any? %>
  <% flash.each do |type, msg|  %>
    <% if type == 'alert' %>
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
      <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% elsif type == 'notice' %>
      <div class="alert alert-primary alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% elsif type == 'errors' %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% elsif type == 'success' %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% else %>
      <div class="alert alert-primary alert-dismissible fade show" role="alert">
        <strong>This type of alert is not explicitly handled. You should update app/views/layouts/_alerts.html.erb</strong>
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    <% end %>
  <% end %>
<% end %>
CODE
end
