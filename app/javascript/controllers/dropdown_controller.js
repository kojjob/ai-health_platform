import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    // Add event listeners for escape key and outside clicks
    document.addEventListener('keydown', this.escapeHandler.bind(this))
    document.addEventListener('click', this.outsideClickHandler.bind(this))
  }
  
  disconnect() {
    // Remove event listeners when controller disconnects
    document.removeEventListener('keydown', this.escapeHandler.bind(this))
    document.removeEventListener('click', this.outsideClickHandler.bind(this))
  }
  
  escapeHandler(e) {
    if (e.key === 'Escape' && this.isOpen()) {
      this.hide()
    }
  }
  
  outsideClickHandler(e) {
    const clickedInside = this.element.contains(e.target)
    if (!clickedInside && this.isOpen()) {
      this.hide()
    }
  }
  
  toggle(event) {
    event.stopPropagation()
    
    if (this.isOpen()) {
      this.hide()
    } else {
      this.closeOtherDropdowns()
      this.show()
    }
  }
  
  show() {
    this.menuTarget.classList.remove('invisible', 'opacity-0', 'scale-95')
    this.menuTarget.classList.add('visible', 'opacity-100', 'scale-100')
  }
  
  hide() {
    this.menuTarget.classList.remove('visible', 'opacity-100', 'scale-100')
    this.menuTarget.classList.add('invisible', 'opacity-0', 'scale-95')
  }
  
  isOpen() {
    return this.menuTarget.classList.contains('visible')
  }
  
  closeOtherDropdowns() {
    document.querySelectorAll('[data-controller="dropdown"]').forEach(dropdown => {
      if (dropdown !== this.element) {
        const controller = this.application.getControllerForElementAndIdentifier(dropdown, 'dropdown')
        if (controller && controller.isOpen()) {
          controller.hide()
        }
      }
    })
  }
}
