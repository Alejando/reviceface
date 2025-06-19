import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    open: { type: Boolean, default: false },
    restoreScroll: { type: Boolean, default: true },
  }

  static targets = ["overlay", "panel"]

  connect() {
    this.boundHandleKeydown = this.handleKeydown.bind(this);
    this.isAnimating = false;
    this.animationLockTimeout = null;

    if (!this.openValue) {
      this.element.classList.add("hidden");
    }
    // openValueChanged will be called with the initial value if data-modal-open-value is present
    // or will use the default, ensuring show/hide is called appropriately.
  }

  disconnect() {
    this.removeKeydownListener();
    if (this.animationLockTimeout) {
      clearTimeout(this.animationLockTimeout);
    }
  }

  openValueChanged(value) {
    if (value) {
      this.show();
    } else {
      this.hide();
    }
  }

  show() {
    // If already visible and not currently animating a hide, do nothing.
    if (!this.element.classList.contains("hidden") && !this.isAnimating) {
      return;
    }

    // If an animation (potentially a hide) is in progress, clear its lock/class-setting timeout.
    if (this.isAnimating) {
      clearTimeout(this.animationLockTimeout);
    }

    this.isAnimating = true;
    this.element.classList.remove("hidden"); // Ensure it's visible for animations
    this.addKeydownListener();

    if (this.restoreScrollValue) {
      this.originalBodyOverflow = document.body.style.overflow;
      document.body.style.overflow = "hidden";
    }

    // Animation: Overlay fade in
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-0");
      this.overlayTarget.classList.add("opacity-100");
    }

    // Animation: Panel transition
    if (this.hasPanelTarget) {
      this.panelTarget.classList.remove("opacity-0", "translate-y-4", "sm:scale-95");
      this.panelTarget.classList.add("opacity-100", "translate-y-0", "sm:scale-100");
    } else {
      console.error("ModalController: panelTarget not found!"); 
    }

    this.animationLockTimeout = setTimeout(() => {
      this.isAnimating = false;
    }, 300); // Animation duration (e.g., 300ms)

    this.element.dispatchEvent(new CustomEvent('modal:opened', { bubbles: true }))
  }

  hide() {
    // If already hidden and not currently animating a show, do nothing.
    if (this.element.classList.contains("hidden") && !this.isAnimating) {
      return;
    }

    // If an animation (potentially a show) is in progress, clear its lock timeout.
    if (this.isAnimating) {
      clearTimeout(this.animationLockTimeout);
    }

    this.isAnimating = true;
    this.removeKeydownListener();

    // Animation: Overlay fade out
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-100");
      this.overlayTarget.classList.add("opacity-0");
    }

    // Animation: Panel transition
    if (this.hasPanelTarget) {
      this.panelTarget.classList.remove("opacity-100", "translate-y-0", "sm:scale-100");
      this.panelTarget.classList.add("opacity-0", "translate-y-4", "sm:scale-95");
    }

    if (this.restoreScrollValue && this.originalBodyOverflow !== undefined) {
      document.body.style.overflow = this.originalBodyOverflow;
    }

    this.animationLockTimeout = setTimeout(() => {
      this.element.classList.add("hidden");
      this.isAnimating = false;
      // If hide was called directly (e.g., ESC) and openValue was true, sync it.
      if (this.openValue) {
        this.openValue = false;
      }
    }, 300); // Animation duration, must match CSS transition time

    this.element.dispatchEvent(new CustomEvent('modal:closed', { bubbles: true }))
  }

  close(event) {
    this.hide();
  }

  closeBackground(event) {
    if (event.target === this.overlayTarget) { 
      this.hide();
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.hide();
    }
  }

  addKeydownListener() {
    document.addEventListener("keydown", this.boundHandleKeydown);
  }

  removeKeydownListener() {
    document.removeEventListener("keydown", this.boundHandleKeydown);
  }
}
