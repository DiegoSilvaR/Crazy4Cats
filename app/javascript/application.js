// application.js (o tu archivo JavaScript/CoffeeScript principal)
document.addEventListener("DOMContentLoaded", function() {
    if (typeof Swal === "function" && $(".alert").length > 0) {
      Swal.fire({
        title: "Alerta",
        text: $(".alert").text(),
        icon: "warning",
      });
    }
  });

// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
