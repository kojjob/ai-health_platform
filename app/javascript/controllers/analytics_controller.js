import { Controller } from "@hotwired/stimulus"

/*
 * Analytics controller to track user interactions and page engagement
 * This controller manages tracking across the marketing site
 */
export default class extends Controller {
  static targets = ["trackable"]
  static values = {
    page: String,
    section: String
  }
  
  connect() {
    // Track page view on controller initialization
    this.trackPageView()
    
    // Set up scroll tracking
    this.setupScrollTracking()
    
    // Add tracking to trackable elements
    if (this.hasTrackableTarget) {
      this.trackableTargets.forEach(element => {
        const eventName = element.dataset.analyticsEvent || "click"
        const category = element.dataset.analyticsCategory || "engagement"
        const label = element.dataset.analyticsLabel || element.textContent.trim()
        
        element.addEventListener(eventName, () => {
          this.trackEvent(category, eventName, label)
        })
      })
    }
  }
  
  disconnect() {
    // Clean up scroll tracking
    this.removeScrollTracking()
  }
  
  trackPageView() {
    if (typeof gtag === 'function') {
      gtag('event', 'page_view', {
        page_title: document.title,
        page_location: window.location.href,
        page_path: window.location.pathname,
        page_section: this.sectionValue || 'main'
      })
    }
  }
  
  trackEvent(category, action, label, value = null) {
    if (typeof gtag === 'function') {
      const eventData = {
        event_category: category,
        event_label: label
      }
      
      if (value !== null) {
        eventData.value = value
      }
      
      gtag('event', action, eventData)
    }
  }
  
  // Track when elements come into view
  setupScrollTracking() {
    this.scrollObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const element = entry.target
            const section = element.dataset.analyticsSection || element.getAttribute('id') || 'unknown'
            
            this.trackEvent('scroll_tracking', 'section_view', section)
            
            // Stop observing after it's been viewed once
            this.scrollObserver.unobserve(element)
          }
        })
      },
      { threshold: 0.5 } // 50% of the element must be visible
    )
    
    // Track main sections
    document.querySelectorAll('section[id], [data-analytics-section]').forEach(section => {
      this.scrollObserver.observe(section)
    })
  }
  
  removeScrollTracking() {
    if (this.scrollObserver) {
      this.scrollObserver.disconnect()
    }
  }
  
  // Track engagement with the page (time spent, scrolling behavior)
  trackEngagement() {
    if (!this.startTime) {
      this.startTime = new Date()
      this.maxScroll = 0
      
      // Track scroll depth
      this.scrollHandler = () => {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop
        const pageHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight
        const scrollPercent = Math.floor((scrollTop / pageHeight) * 100)
        
        if (scrollPercent > this.maxScroll) {
          this.maxScroll = scrollPercent
        }
      }
      
      window.addEventListener('scroll', this.scrollHandler)
      
      // Track when user leaves the page
      this.beforeUnloadHandler = () => {
        const now = new Date()
        const timeSpent = Math.round((now - this.startTime) / 1000) // in seconds
        
        this.trackEvent('engagement', 'time_spent', this.pageValue || window.location.pathname, timeSpent)
        this.trackEvent('engagement', 'max_scroll_percentage', this.pageValue || window.location.pathname, this.maxScroll)
      }
      
      window.addEventListener('beforeunload', this.beforeUnloadHandler)
    }
  }
}
