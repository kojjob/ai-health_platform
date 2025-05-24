import { Controller } from "@hotwired/stimulus"

/**
 * Scroll Animation Controller
 * Animates elements as they enter the viewport during scrolling
 *
 * Usage:
 * <div data-controller="scroll-animate">
 *   <div data-scroll-animate-target="element" data-animation="fade-in">...</div>
 *   <div data-scroll-animate-target="element" data-animation="fade-in-up" data-animation-delay="200">...</div>
 * </div>
 */
export default class extends Controller {
  static targets = ["element"]
  
  connect() {
    this.setupIntersectionObserver()
    this.animateElementsInView()
  }
  
  setupIntersectionObserver() {
    const options = {
      root: null, // viewport
      rootMargin: '0px',
      threshold: 0.1 // 10% of element needs to be visible
    }
    
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.animateElement(entry.target)
          this.observer.unobserve(entry.target) // Only animate once
        }
      })
    }, options)
    
    // Start observing all elements
    this.elementTargets.forEach(element => {
      this.observer.observe(element)
    })
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
  
  animateElementsInView() {
    // Immediately animate elements that are already in the viewport on page load
    this.elementTargets.forEach(element => {
      const rect = element.getBoundingClientRect()
      const isInViewport = (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
      )
      
      if (isInViewport) {
        this.animateElement(element)
      }
    })
  }
  
  animateElement(element) {
    const animation = element.dataset.animation || 'fade-in'
    const delay = element.dataset.animationDelay || 0
    
    // Add pre-animation state class if not already present
    element.classList.add(`${animation}-pre`)
    
    // Trigger animation after delay
    setTimeout(() => {
      element.classList.remove(`${animation}-pre`)
      element.classList.add(animation)
    }, parseInt(delay))
  }
}
