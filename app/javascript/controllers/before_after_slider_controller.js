import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slider", "beforeImage", "afterImage", "handle", "overlay"]
  static values = {
    initial: { type: Number, default: 50 } // Initial position as percentage (50%)
  }
  
  connect() {
    if (this.hasSliderTarget && this.hasBeforeImageTarget && this.hasAfterImageTarget && this.hasHandleTarget) {
      this.sliderWidth = this.sliderTarget.offsetWidth
      this.setInitialPosition()
      this.addEventListeners()
      
      // Add hint animation to make interaction more obvious to users
      this.addInteractionHint()
      
      // Track impression for analytics
      if (typeof gtag === 'function') {
        gtag('event', 'impression', {
          'event_category': 'interactive_element',
          'event_label': 'before_after_slider'
        })
      }
    }
  }
  
  // Add a subtle animation to encourage users to interact with the slider
  addInteractionHint() {
    // Create a hint element
    const hintElement = document.createElement('div')
    hintElement.className = 'absolute top-2 left-1/2 transform -translate-x-1/2 bg-black bg-opacity-70 text-white px-4 py-2 rounded-full text-sm shadow-lg z-10'
    hintElement.innerHTML = 'Slide to compare <i class="fas fa-arrows-left-right ml-1"></i>'
    this.sliderTarget.appendChild(hintElement)
    
    // Add animation to the handle
    const addHintAnimation = () => {
      this.handleTarget.classList.add('animate-pulse-slow')
      
      // Show a subtle animation on the slider to indicate it's draggable
      const currentPos = this.currentPosition || this.initialValue
      const targetPos = currentPos > 70 ? currentPos - 15 : currentPos + 15
      
      // Animate the slider handle slightly to show it can be moved
      setTimeout(() => {
        this.animatePosition(currentPos, targetPos, 1000)
        
        // Hide hint after animation completes
        setTimeout(() => {
          hintElement.classList.add('opacity-0', 'transition-opacity', 'duration-500')
          setTimeout(() => {
            hintElement.remove()
          }, 500)
        }, 1000)
      }, 1000)
    }
    
    // Start the hint animation after a delay
    setTimeout(addHintAnimation, 1000)
  }
  
  // Animate the slider position smoothly
  animatePosition(start, end, duration) {
    const startTime = performance.now()
    
    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      
      // Easing function
      const easeInOut = t => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
      const easedProgress = easeInOut(progress)
      
      const position = start + (end - start) * easedProgress
      this.setPosition(position)
      
      if (progress < 1) {
        requestAnimationFrame(animate)
      } else {
        this.handleTarget.classList.remove('animate-pulse-slow')
      }
    }
    
    requestAnimationFrame(animate)
  }
  
  disconnect() {
    this.removeEventListeners()
  }
  
  addEventListeners() {
    this.sliderTarget.addEventListener('mousedown', this.startDragging.bind(this))
    this.sliderTarget.addEventListener('touchstart', this.startDragging.bind(this), { passive: true })
    document.addEventListener('mousemove', this.drag.bind(this))
    document.addEventListener('touchmove', this.drag.bind(this), { passive: false })
    document.addEventListener('mouseup', this.stopDragging.bind(this))
    document.addEventListener('touchend', this.stopDragging.bind(this))
  }
  
  removeEventListeners() {
    this.sliderTarget.removeEventListener('mousedown', this.startDragging.bind(this))
    this.sliderTarget.removeEventListener('touchstart', this.startDragging.bind(this))
    document.removeEventListener('mousemove', this.drag.bind(this))
    document.removeEventListener('touchmove', this.drag.bind(this))
    document.removeEventListener('mouseup', this.stopDragging.bind(this))
    document.removeEventListener('touchend', this.stopDragging.bind(this))
  }
  
  setInitialPosition() {
    const position = this.initialValue
    this.setPosition(position)
  }
  
  startDragging(e) {
    e.preventDefault()
    this.isDragging = true
    this.sliderTarget.classList.add('cursor-grabbing')
    
    // Track interaction start for analytics
    if (typeof gtag === 'function') {
      gtag('event', 'interaction_start', {
        'event_category': 'interactive_element',
        'event_label': 'before_after_slider'
      })
    }
  }
  
  stopDragging() {
    this.isDragging = false
    this.sliderTarget.classList.remove('cursor-grabbing')
    
    // Track interaction complete for analytics
    if (typeof gtag === 'function') {
      gtag('event', 'interaction_complete', {
        'event_category': 'interactive_element',
        'event_label': 'before_after_slider',
        'position_percent': Math.round(this.currentPosition)
      })
    }
  }
  
  drag(e) {
    if (!this.isDragging) return
    
    e.preventDefault()
    
    // Get cursor position
    let clientX
    if (e.type === 'touchmove') {
      clientX = e.touches[0].clientX
    } else {
      clientX = e.clientX
    }
    
    // Get relative position
    const rect = this.sliderTarget.getBoundingClientRect()
    let position = ((clientX - rect.left) / rect.width) * 100
    
    // Constrain position to slider bounds
    position = Math.max(0, Math.min(100, position))
    
    this.setPosition(position)
  }
  
  setPosition(position) {
    this.currentPosition = position
    
    // Update the handle position
    this.handleTarget.style.left = `${position}%`
    
    // Update the overlay width
    if (this.hasOverlayTarget) {
      this.overlayTarget.style.width = `${position}%`
    }
    
    // Update the before image clip - improved clipping with browser prefixes for better compatibility
    this.beforeImageTarget.style.clipPath = `inset(0 ${100 - position}% 0 0)`
    this.beforeImageTarget.style.webkitClipPath = `inset(0 ${100 - position}% 0 0)`
    
    // Force repaint to prevent visual glitches
    this.beforeImageTarget.style.transform = 'translateZ(0)'
  }
}
