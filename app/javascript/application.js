// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import NotificationHelper from "notification_helper"

// Expose NotificationHelper globally
window.NotificationHelper = NotificationHelper;
