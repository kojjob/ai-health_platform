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
    // Ensure all accordions start closed and have transition classes
    this.contentTargets.forEach((content, index) => {
      // Add transition classes to all content elements
      content.classList.add('hidden', 'overflow-hidden', 'transition-all', 'duration-300', 'ease-in-out', 'opacity-0')
      
      // Add data-index attribute to match content with its button
      content.dataset.index = index
      
      // Find the corresponding button and add the index
      const buttons = this.element.querySelectorAll('[data-action="click->accordion#toggle"]')
      if (buttons[index]) {
        buttons[index].dataset.index = index
      }
    })
  }
  
  toggle(event) {
    // Find the nearest content and icon targets relative to the clicked button
    const button = event.currentTarget
    const content = button.nextElementSibling
    const icon = button.querySelector('i')
    
    // Close any currently open accordions in the same group
    this.closeOtherAccordions(button)
    
    // Toggle the content visibility with smooth transition
    if (content.classList.contains('hidden')) {
      // Show content with transition
      content.classList.remove('hidden')
      content.classList.add('max-h-0')
      setTimeout(() => {
        content.classList.remove('max-h-0')
        content.classList.add('max-h-96', 'opacity-100')
      }, 10)
      
      // Rotate icon for open state
      icon.classList.add('rotate-45')
    } else {
      // Hide content with transition
      content.classList.remove('max-h-96', 'opacity-100')
      content.classList.add('max-h-0')
      setTimeout(() => {
        content.classList.add('hidden')
      }, 300) // Match with CSS transition duration
      
      // Reset icon rotation
      icon.classList.remove('rotate-45')
    }
  }
  
  closeOtherAccordions(currentButton) {
    // Close all other accordions in this controller
    const buttons = this.element.querySelectorAll('[data-action="click->accordion#toggle"]')
    buttons.forEach(button => {
      if (button !== currentButton) {
        const content = button.nextElementSibling
        const icon = button.querySelector('i')
        
        // Only process elements that are open
        if (!content.classList.contains('hidden')) {
          // Hide with transition
          content.classList.remove('max-h-96', 'opacity-100')
          content.classList.add('max-h-0')
          setTimeout(() => {
            content.classList.add('hidden')
          }, 300)
          
          // Reset icon rotation
          if (icon) {
            icon.classList.remove('rotate-45')
          }
        }
      }
    })
  }
}
