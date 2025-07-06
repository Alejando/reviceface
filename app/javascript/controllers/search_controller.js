import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    // Debounce setup
    this.timeout = null
  }

  submit() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      let pageInput = this.element.querySelector('input[name="page"]')
      if (!pageInput) {
        pageInput = document.createElement('input')
        pageInput.type = 'hidden'
        pageInput.name = 'page'
        this.element.appendChild(pageInput)
      }
      pageInput.value = '1'
      
      this.element.requestSubmit()
    }, 300) // 300ms debounce
  }
}
