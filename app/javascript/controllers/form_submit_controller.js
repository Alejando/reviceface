import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submit"
export default class extends Controller {
  static values = { modalId: String } // ID of the modal to close

  connect() {
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      const modalId = this.modalIdValue
      if (!modalId) {
        console.error("Modal ID is missing for form-submit-controller")
        return
      }

      const modalElement = document.getElementById(modalId)
      if (!modalElement) {
        console.error(`Modal element with ID "${modalId}" not found for form-submit-controller.`)
        return
      }

      const modalController = this.application.getControllerForElementAndIdentifier(modalElement, "modal")

      if (modalController) {
        modalController.openValue = false // This will trigger the hide method in modal_controller
      } else {
        console.error(`Modal controller not found on element with ID "${modalId}". Ensure it has data-controller="modal".`)
      }
    } else {
      // Optional: Handle form submission errors, e.g., re-enable submit button if it was disabled
      // Or, if your Rails controller responds with a Turbo Stream to replace the form with errors,
      // that will happen automatically.
      console.log("Form submission failed or was cancelled.", event.detail)
    }
  }
}
