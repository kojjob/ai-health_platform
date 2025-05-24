import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["incident", "details", "refreshButton", "lastUpdated"]
  
  connect() {
    // Set up automatic refresh if configured
    if (this.hasRefreshButtonTarget && this.data.has("refreshInterval")) {
      this.startRefreshTimer()
    }
  }
  
  disconnect() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }
  
  toggleDetails(event) {
    // Find the incident details container within the clicked incident
    const incident = event.currentTarget
    const details = incident.querySelector("[data-status-page-target='details']")
    
    // Toggle the visibility
    if (details) {
      details.classList.toggle("hidden")
      
      // Toggle the icon
      const icon = incident.querySelector("i.toggle-icon")
      if (icon) {
        icon.classList.toggle("fa-chevron-down")
        icon.classList.toggle("fa-chevron-up")
      }
    }
  }
  
  refreshStatus() {
    // Show loading state
    if (this.hasRefreshButtonTarget) {
      this.refreshButtonTarget.classList.add("animate-spin")
    }
    
    // Make an AJAX request to get the current system status
    fetch('/system-status')
      .then(response => response.json())
      .then(data => {
        this.updateStatusDisplay(data)
        
        if (this.hasLastUpdatedTarget) {
          const now = new Date()
          this.lastUpdatedTarget.textContent = now.toLocaleTimeString()
        }
        
        // Remove loading state
        if (this.hasRefreshButtonTarget) {
          this.refreshButtonTarget.classList.remove("animate-spin")
        }
        
        // Flash the status indicators to show they've been updated
        document.querySelectorAll(".status-indicator").forEach(indicator => {
          indicator.classList.add("pulse")
          setTimeout(() => {
            indicator.classList.remove("pulse")
          }, 1000)
        })
      })
      .catch(error => {
        console.error('Error fetching system status:', error)
        
        // Remove loading state
        if (this.hasRefreshButtonTarget) {
          this.refreshButtonTarget.classList.remove("animate-spin")
        }
      })
  }
  
  startRefreshTimer() {
    const interval = parseInt(this.data.get("refreshInterval")) * 1000
    this.refreshTimer = setInterval(() => {
      this.refreshStatus()
    }, interval)
  }
  
  updateStatusDisplay(data) {
    // Update overall system status
    const overallStatusContainer = document.querySelector('.overall-status')
    if (overallStatusContainer) {
      let statusIcon = '<i class="fas fa-check text-white"></i>'
      let statusClass = 'bg-green-500'
      let statusText = 'All Systems Operational'
      
      if (data.overall === 'degraded') {
        statusIcon = '<i class="fas fa-exclamation text-white"></i>'
        statusClass = 'bg-yellow-500'
        statusText = 'Partial Service Degradation'
      } else if (data.overall === 'outage') {
        statusIcon = '<i class="fas fa-times text-white"></i>'
        statusClass = 'bg-red-500'
        statusText = 'Service Disruption'
      }
      
      // Update the UI elements
      const statusIconElement = overallStatusContainer.querySelector('.status-icon-container')
      if (statusIconElement) {
        statusIconElement.className = `w-8 h-8 ${statusClass} rounded-full flex items-center justify-center`
        statusIconElement.innerHTML = statusIcon
      }
      
      const statusTextElement = overallStatusContainer.querySelector('.status-text')
      if (statusTextElement) {
        statusTextElement.textContent = statusText
      }
    }
    
    // Update individual component statuses
    if (data.components) {
      data.components.forEach(component => {
        const componentEl = document.querySelector(`[data-component-id="${component.name}"]`)
        if (componentEl) {
          // Update status indicator
          const statusIndicator = componentEl.querySelector('.status-indicator')
          if (statusIndicator) {
            statusIndicator.className = `status-indicator w-3 h-3 rounded-full mr-2 ${this.getStatusColor(component.status)}`
          }
          
          // Update uptime text
          const uptimeEl = componentEl.querySelector('.uptime')
          if (uptimeEl && component.uptime) {
            uptimeEl.textContent = component.uptime
          }
        }
      })
    }
  }
  
  getStatusColor(status) {
    switch (status.toLowerCase()) {
      case 'operational':
        return 'bg-green-500'
      case 'degraded':
        return 'bg-yellow-500'
      case 'outage':
        return 'bg-red-500'
      default:
        return 'bg-gray-500'
    }
  }
  
  requestNotifications() {
    // Check if browser supports notifications
    if (!("Notification" in window)) {
      alert("This browser does not support desktop notifications")
      return
    }
    
    // Request permission
    Notification.requestPermission().then(permission => {
      if (permission === "granted") {
        // Save preference (in a real app, this would be sent to the server)
        console.log("Notification permission granted")
        
        // Show confirmation
        const notification = new Notification("MedGemma Health Status", {
          body: "You will now receive notifications about system status changes.",
          icon: "/assets/logo.png"
        })
        
        // Update UI to show enabled state
        const notificationButton = event.currentTarget
        notificationButton.innerHTML = `
          <i class="fas fa-bell-slash mr-2"></i>
          Disable Browser Notifications
        `
        notificationButton.classList.remove('bg-blue-100', 'text-blue-700')
        notificationButton.classList.add('bg-gray-100', 'text-gray-700')
        notificationButton.setAttribute('data-action', 'click->status-page#disableNotifications')
      }
    })
  }
}
