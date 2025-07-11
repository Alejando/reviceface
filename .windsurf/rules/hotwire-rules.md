---
trigger: always_on
---

---
trigger: glob
description: This rule explains Hotwire (Turbo and Stimulus) patterns for modern Rails applications.
globs: **/*.erb,**/*.html
---

# Hotwire rules

- Use Turbo Frames for partial page updates without writing JavaScript:

```erb
<%= turbo_frame_tag "user_list" do %>
  <%= render partial: "user", collection: @users %>
<% end %>
```

- Use Turbo Streams for real-time updates:

```erb
<%= turbo_stream.append "posts" do %>
  <%= render partial: "post", locals: { post: @post } %>
<% end %>
```

- Use Stimulus controllers for JavaScript behavior:

```erb
<div data-controller="hello">
  <input data-hello-target="name" type="text">
  <button data-action="click->hello#greet">Greet</button>
</div>
```

- Use Turbo Drive for navigation without full page reloads (enabled by default).
- Disable Turbo for specific links with `data: { turbo: false }`.
- Use Stimulus Values API for configuration with `data-controller-value-name="value"` attributes.
