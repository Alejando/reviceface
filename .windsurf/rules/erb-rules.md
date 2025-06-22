---
trigger: always_on
---

---
trigger: glob
description: This rule explains ERB template syntax and best practices for Ruby applications.
globs: **/*.erb
---

# ERB rules

- Use proper ERB tags for different purposes:
  - `<% %>` for Ruby code without output
  - `<%= %>` for Ruby code with output
  - `<%# %>` for comments
  - `<%- -%>` for whitespace control

- Use partials for reusable components:

```erb
<%= render partial: "shared/user_card", locals: { user: @user } %>
<%= render partial: "shared/user_card", collection: @users, as: :user %>
```

- Use content_for and yield for layout sections:

```erb
<% content_for :head do %>
  <meta name="description" content="<%= @page_description %>">
<% end %>
```

- Use helpers for complex view logic instead of putting logic in templates.
- Use form builders for consistent forms with `form_with` and `form_for`.
- Use link_to and button_to for links and buttons instead of raw HTML.
- Use translations with the `t()` helper for internationalization.
