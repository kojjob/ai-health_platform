import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "answer", "icon"]
  
  connect() {
    // Hide all answers except the first one on initial load
    if (this.questionTargets.length > 0) {
      this.questionTargets.forEach((question, index) => {
        const answer = this.answerTargets[index]
        const icon = this.iconTargets[index]
        
        if (index === 0) {
          answer.style.display = "block"
          icon.classList.add("transform", "rotate-180")
        } else {
          answer.style.display = "none"
        }
      })
    }
  }
  
  toggle(event) {
    const clickedQuestion = event.currentTarget
    const clickedIndex = this.questionTargets.indexOf(clickedQuestion)
    const answer = this.answerTargets[clickedIndex]
    const icon = this.iconTargets[clickedIndex]
    
    // Toggle answer visibility
    if (answer.style.display === "none" || answer.style.display === "") {
      answer.style.display = "block"
    } else {
      answer.style.display = "none"
    }
    
    // Rotate icon
    icon.classList.toggle("rotate-180")
    
    // Animate the question
    clickedQuestion.classList.toggle("text-medgemma-600")
    
    // Optional: close other open FAQs
    this.questionTargets.forEach((question, index) => {
      if (index !== clickedIndex && this.answerTargets[index].style.display === "block") {
        this.answerTargets[index].style.display = "none"
        this.iconTargets[index].classList.remove("rotate-180")
        question.classList.remove("text-medgemma-600")
      }
    })
    
    // Track FAQ interaction for analytics
    if (typeof gtag === 'function') {
      gtag('event', 'faq_interaction', {
        'faq_question': clickedQuestion.textContent.trim(),
        'faq_opened': !answer.classList.contains("hidden")
      });
    }
  }
}
