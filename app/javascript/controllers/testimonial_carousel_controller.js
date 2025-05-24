import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "indicator"]
  
  connect() {
    this.currentIndex = 0
    this.showCurrentSlide()
    
    // Auto-advance the carousel every 5 seconds
    this.autoAdvanceTimer = setInterval(() => {
      this.next()
    }, 5000)
  }
  
  disconnect() {
    if (this.autoAdvanceTimer) {
      clearInterval(this.autoAdvanceTimer)
    }
  }
  
  showCurrentSlide() {
    this.slideTargets.forEach((slide, index) => {
      if (index === this.currentIndex) {
        slide.classList.remove("hidden")
        slide.classList.add("animate-fade-in", "testimonial-current")
        
        // Add a slight delay to ensure the animation is visible
        setTimeout(() => {
          slide.classList.add("testimonial-visible")
        }, 50)
      } else {
        slide.classList.add("hidden")
        slide.classList.remove("animate-fade-in", "testimonial-current", "testimonial-visible")
      }
    })
    
    this.indicatorTargets.forEach((indicator, index) => {
      if (index === this.currentIndex) {
        indicator.classList.remove("bg-gray-300", "w-3", "h-3")
        indicator.classList.add("bg-medgemma-500", "w-5", "h-3", "animate-pulse-slow")
      } else {
        indicator.classList.remove("bg-medgemma-500", "w-5", "animate-pulse-slow")
        indicator.classList.add("bg-gray-300", "w-3", "h-3")
      }
    })
  }
  
  next() {
    // Get the current slide and prepare it for animation
    const currentSlide = this.slideTargets[this.currentIndex]
    currentSlide.classList.add('testimonial-exit-left')
    
    // Update index
    this.currentIndex = (this.currentIndex + 1) % this.slideTargets.length
    
    // Show the next slide with animation
    setTimeout(() => {
      this.showCurrentSlide()
      currentSlide.classList.remove('testimonial-exit-left')
    }, 300)
    
    // Track interaction with analytics
    this.trackInteraction('next')
  }
  
  previous() {
    // Get the current slide and prepare it for animation
    const currentSlide = this.slideTargets[this.currentIndex]
    currentSlide.classList.add('testimonial-exit-right')
    
    // Update index
    this.currentIndex = (this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length
    
    // Show the next slide with animation
    setTimeout(() => {
      this.showCurrentSlide()
      currentSlide.classList.remove('testimonial-exit-right')
    }, 300)
    
    // Track interaction with analytics
    this.trackInteraction('previous')
  }
  
  trackInteraction(direction) {
    if (typeof gtag === 'function') {
      gtag('event', 'testimonial_navigation', {
        'event_category': 'interactive_element',
        'event_label': `testimonial_${direction}`,
        'current_slide': this.currentIndex + 1
      })
    }
  }
  
  goToSlide(event) {
    const clickedIndex = this.indicatorTargets.indexOf(event.currentTarget)
    if (clickedIndex !== -1) {
      this.currentIndex = clickedIndex
      this.showCurrentSlide()
      
      // Reset the auto-advance timer
      clearInterval(this.autoAdvanceTimer)
      this.autoAdvanceTimer = setInterval(() => {
        this.next()
      }, 5000)
    }
  }
}
