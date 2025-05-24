import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["background", "mobileMenu"]

  connect() {
    this.handleScroll()
    window.addEventListener('scroll', this.handleScroll.bind(this))
  }

  disconnect() {
    window.removeEventListener('scroll', this.handleScroll.bind(this))
  }

  handleScroll() {
    const scrolled = window.scrollY > 50
    
    if (scrolled) {
      this.backgroundTarget.classList.remove('opacity-0')
      this.backgroundTarget.classList.add('opacity-100')
    } else {
      this.backgroundTarget.classList.remove('opacity-100')
      this.backgroundTarget.classList.add('opacity-0')
    }
  }

  toggleMobile() {
    this.mobileMenuTarget.classList.toggle('hidden')
  }
}