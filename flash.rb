def set_flash
  file 'app/views/layouts/_alerts.html.erb', <<-CODE
<% if flash.any? %>
  <% flash.each do |type, msg|  %>
    <% if type == 'alert' %>
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% elsif type == 'notice' %>
      <div class="alert alert-primary alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% elsif type == 'errors' %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% elsif type == 'success' %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% else %>
      <div class="alert alert-primary alert-dismissible fade show" role="alert">
        <strong>This type of alert is not explicitly handled. You should update app/views/layouts/_alerts.html.erb</strong>
        <%= msg %>
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
    <% end %>
  <% end %>
<% end %>
CODE
end
