import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["topicCount", "replyCount", "viewCount", "forum", "discussion"]

  connect() {
    console.log("Community controller connected")
  }
  
  // Method to simulate joining a forum
  joinForum(event) {
    const forumElement = event.currentTarget.closest("[data-community-target='forum']")
    const joinButton = event.currentTarget
    
    // Simulate joining process
    joinButton.innerHTML = '<i class="fas fa-circle-notch fa-spin mr-2"></i> Joining...'
    
    setTimeout(() => {
      // Update button to show joined state
      joinButton.innerHTML = '<i class="fas fa-check mr-2"></i> Joined'
      joinButton.classList.remove("bg-purple-100", "hover:bg-purple-200", "text-purple-700")
      joinButton.classList.add("bg-purple-700", "text-white")
      
      // Increment member count
      if (forumElement) {
        const memberCountElement = forumElement.querySelector(".member-count")
        if (memberCountElement) {
          const currentCount = parseInt(memberCountElement.textContent)
          memberCountElement.textContent = currentCount + 1
        }
      }
    }, 1500)
  }
  
  // Method to simulate liking a discussion
  likeDiscussion(event) {
    const button = event.currentTarget
    const likeIcon = button.querySelector("i")
    
    if (likeIcon.classList.contains("far")) { // Not liked yet
      likeIcon.classList.remove("far")
      likeIcon.classList.add("fas", "text-red-500")
      
      const likeCountElement = button.querySelector("span")
      if (likeCountElement) {
        const currentLikes = parseInt(likeCountElement.textContent)
        likeCountElement.textContent = currentLikes + 1
      }
    } else {
      likeIcon.classList.remove("fas", "text-red-500")
      likeIcon.classList.add("far")
      
      const likeCountElement = button.querySelector("span")
      if (likeCountElement) {
        const currentLikes = parseInt(likeCountElement.textContent)
        likeCountElement.textContent = Math.max(0, currentLikes - 1)
      }
    }
  }
  
  // Method to filter discussions by category
  filterDiscussions(event) {
    const category = event.currentTarget.dataset.category
    const discussions = this.discussionTargets
    
    // Set active state on filter button
    document.querySelectorAll("[data-action='click->community#filterDiscussions']").forEach(btn => {
      btn.classList.remove("bg-purple-100", "text-purple-800")
      btn.classList.add("bg-gray-100", "text-gray-700")
    })
    
    event.currentTarget.classList.remove("bg-gray-100", "text-gray-700")
    event.currentTarget.classList.add("bg-purple-100", "text-purple-800")
    
    // Filter discussions
    if (category === "all") {
      discussions.forEach(discussion => {
        discussion.classList.remove("hidden")
      })
    } else {
      discussions.forEach(discussion => {
        if (discussion.dataset.category === category) {
          discussion.classList.remove("hidden")
        } else {
          discussion.classList.add("hidden")
        }
      })
    }
  }
}
