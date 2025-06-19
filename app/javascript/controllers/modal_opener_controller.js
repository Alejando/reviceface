import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal-opener"
export default class extends Controller {
  static values = { target: String } // ID of the modal to open

  open() {
    const modalId = this.targetValue;
    if (!modalId) {
      console.error("Modal target ID is missing for modal-opener-controller")
      return
    }

    const modalElement = document.getElementById(modalId);
    if (!modalElement) {
      console.error(`Modal element with ID "${modalId}" not found.`)
      return
    }

    // Assuming the modal element has a Stimulus controller named "modal"
    // and that controller has an `openValue` (boolean)
    const modalController = this.application.getControllerForElementAndIdentifier(modalElement, "modal");

    if (modalController) {
      modalController.openValue = true;
    } else {
      console.error(`Modal controller not found on element with ID "${modalId}". Ensure it has data-controller="modal".`)
    }
  }
}