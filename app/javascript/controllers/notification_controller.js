import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 0 },
    position: { type: String, default: "top-right" }
  }
  
  connect() {
    // Add entrance animation based on position
    this.addEntranceAnimation()
    
    // Set timeout for auto-dismissal if timeout is provided
    if (this.timeoutValue > 0) {
      this.dismissTimeout = setTimeout(() => {
        this.dismiss()
      }, this.timeoutValue)
    }
    
    // Pause timeout on hover
    this.element.addEventListener("mouseenter", this.pauseTimeout.bind(this))
    this.element.addEventListener("mouseleave", this.resumeTimeout.bind(this))
  }
  
  disconnect() {
    if (this.dismissTimeout) {
      clearTimeout(this.dismissTimeout)
    }
    
    this.element.removeEventListener("mouseenter", this.pauseTimeout.bind(this))
    this.element.removeEventListener("mouseleave", this.resumeTimeout.bind(this))
  }
  
  pauseTimeout() {
    if (this.dismissTimeout) {
      clearTimeout(this.dismissTimeout)
      this.remainingTime = this.timeoutValue - (Date.now() - this.startTime)
    }
  }
  
  resumeTimeout() {
    if (this.remainingTime) {
      this.dismissTimeout = setTimeout(() => {
        this.dismiss()
      }, this.remainingTime)
    }
  }
  
  addEntranceAnimation() {
    this.startTime = Date.now()
    
    // Base animation classes
    this.element.classList.add("transform", "transition-all", "duration-300", "ease-out")
    
    // Position-specific animations
    switch(this.positionValue) {
      case "top-right":
        this.element.classList.add("translate-x-full", "opacity-0")
        break
      case "top-left":
        this.element.classList.add("-translate-x-full", "opacity-0")
        break
      case "bottom-right":
        this.element.classList.add("translate-x-full", "opacity-0")
        break
      case "bottom-left":
        this.element.classList.add("-translate-x-full", "opacity-0")
        break
      case "top-center":
        this.element.classList.add("-translate-y-full", "opacity-0")
        break
      case "bottom-center":
        this.element.classList.add("translate-y-full", "opacity-0")
        break
      default:
        this.element.classList.add("translate-x-full", "opacity-0")
    }
    
    // Trigger animation after a small delay
    setTimeout(() => {
      this.element.classList.remove(
        "translate-x-full", "-translate-x-full",
        "translate-y-full", "-translate-y-full",
        "opacity-0"
      )
    }, 10)
  }
  
  dismiss() {
    // Add exit animation
    this.element.classList.add("opacity-0")
    
    // Add position-specific exit animations
    switch(this.positionValue) {
      case "top-right":
        this.element.classList.add("translate-x-full")
        break
      case "top-left":
        this.element.classList.add("-translate-x-full")
        break
      case "bottom-right":
        this.element.classList.add("translate-x-full")
        break
      case "bottom-left":
        this.element.classList.add("-translate-x-full")
        break
      case "top-center":
        this.element.classList.add("-translate-y-full")
        break
      case "bottom-center":
        this.element.classList.add("translate-y-full")
        break
      default:
        this.element.classList.add("translate-x-full")
    }
    
    // Remove element after animation completes
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
