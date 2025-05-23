import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    this.hideTimeout = null
  }
  
  show() {
    this.cancelHide()
    this.menuTarget.classList.add("visible", "opacity-100")
    this.menuTarget.classList.remove("invisible", "opacity-0")
  }
  
  hideWithDelay() {
    this.hideTimeout = setTimeout(() => {
      this.hide()
    }, 300)
  }
  
  cancelHide() {
    if (this.hideTimeout) {
      clearTimeout(this.hideTimeout)
      this.hideTimeout = null
    }
  }
  
  hide() {
    this.menuTarget.classList.remove("visible", "opacity-100")
    this.menuTarget.classList.add("invisible", "opacity-0")
  }
}
