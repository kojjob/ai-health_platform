import { Controller } from "@hotwired/stimulus"

/*
 * FAQ Accordion Controller
 * Controls the opening and closing of FAQ items
 *
 * <div data-controller="accordion">
 *   <button data-action="click->accordion#toggle">
 *     FAQ Question
 *     <i class="fas fa-plus text-blue-600 transform transition-transform duration-300"></i>
 *   </button>
 *   <div data-accordion-target="content">Answer content here</div>
 * </div>
 */

export default class extends Controller {
  static targets = ["content", "icon"]
  
  connect() {
    console.log("Accordion controller connected");
    
    // Ensure all accordions start closed
    this.contentTargets.forEach((content, index) => {
      content.classList.add('hidden')
      content.style.maxHeight = '0px'
      content.style.opacity = '0'
      content.dataset.index = index.toString()
      
      // Find corresponding icon and add index
      const icons = this.iconTargets.filter(icon => !icon.dataset.index)
      if (icons[index]) {
        icons[index].dataset.index = index.toString()
      }
    })
    
    // Make sure buttons have indexes
    const buttons = this.element.querySelectorAll('[data-action="click->accordion#toggle"]')
    buttons.forEach((button, index) => {
      if (!button.dataset.index) {
        button.dataset.index = index.toString()
      }
    })
  }
  
  toggle(event) {
    const button = event.currentTarget
    const index = button.dataset.index
    const content = this.findContentByIndex(index)
    const icon = this.findIconByIndex(index)
    
    if (!content) {
      console.error("No content found for index:", index)
      return
    }
    
    // Close other accordions first
    this.closeOtherAccordions(index)
    
    // Toggle current accordion with a slight delay
    setTimeout(() => {
      if (content.classList.contains('hidden')) {
        // Open
        content.classList.remove('hidden')
        setTimeout(() => {
          content.style.maxHeight = content.scrollHeight + 'px'
          content.style.opacity = '1'
          content.classList.add('open')
        }, 10)
        
        if (icon) {
          icon.style.transform = 'rotate(180deg)'
        }
      } else {
        // Close
        content.style.maxHeight = '0px'
        content.style.opacity = '0'
        content.classList.remove('open')
        
        if (icon) {
          icon.style.transform = 'rotate(0deg)'
        }
        
        setTimeout(() => {
          content.classList.add('hidden')
        }, 300)
      }
    }, 50)
  }
  
  findContentByIndex(index) {
    return this.contentTargets.find(target => target.dataset.index === index.toString())
  }
  
  findIconByIndex(index) {
    return this.iconTargets.find(target => target.dataset.index === index.toString())
  }
  
  closeOtherAccordions(currentIndex) {
    this.contentTargets.forEach(content => {
      if (content.dataset.index !== currentIndex && !content.classList.contains('hidden')) {
        const icon = this.findIconByIndex(content.dataset.index)
        
        content.style.maxHeight = '0px'
        content.style.opacity = '0'
        content.classList.remove('open')
        
        if (icon) {
          icon.style.transform = 'rotate(0deg)'
        }
        
        setTimeout(() => {
          content.classList.add('hidden')
        }, 300)
      }
    })
  }
}
