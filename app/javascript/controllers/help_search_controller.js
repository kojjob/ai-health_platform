import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "commonSearches"]
  
  connect() {
    // Initialize search functionality
    console.log("Help search controller connected")
  }
  
  search() {
    const query = this.inputTarget.value.trim().toLowerCase()
    
    if (query.length < 2) {
      this.hideResults()
      return
    }
    
    // Make an AJAX request to the server-side search endpoint
    this.fetchResults(query)
  }
  
  fetchResults(query) {
    // Show loading state
    this.resultsTarget.innerHTML = `
      <div class="p-4 text-center">
        <div class="inline-block animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        <p class="mt-2 text-gray-500">Searching...</p>
      </div>
    `
    this.showResults()
    
    // Fetch results from the server
    fetch(`/help-search?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.displayResults(data)
      })
      .catch(error => {
        console.error('Error fetching search results:', error)
        this.resultsTarget.innerHTML = `
          <div class="p-4 text-center">
            <p class="text-red-500">Error loading results. Please try again.</p>
          </div>
        `
      })
  }
  
  displayResults(results) {
    if (results.length === 0) {
      this.resultsTarget.innerHTML = `
        <div class="p-4 text-center">
          <p class="text-gray-500">No results found. Please try another search term.</p>
        </div>
      `
    } else {
      const html = results.map(result => `
        <a href="${result.path}" class="block border-b border-gray-100 last:border-0 p-4 hover:bg-blue-50 transition-colors">
          <div class="flex items-center">
            <span class="inline-flex items-center justify-center w-8 h-8 mr-3 rounded-full bg-blue-100 text-blue-500">
              <i class="fas fa-search"></i>
            </span>
            <div>
              <h4 class="font-medium text-gray-900">${result.title}</h4>
              <span class="text-sm text-blue-600">${result.category}</span>
              ${result.content ? `<p class="text-sm text-gray-500 mt-1 line-clamp-2">${result.content}</p>` : ''}
            </div>
          </div>
        </a>
      `).join('')
      
      this.resultsTarget.innerHTML = html
    }
    
    this.showResults()
  }
  
  quickSearch(event) {
    const term = event.currentTarget.textContent
    this.inputTarget.value = term
    this.search()
  }
  
  showResults() {
    this.resultsTarget.classList.remove("hidden")
    this.commonSearchesTarget.classList.add("hidden")
  }
  
  hideResults() {
    this.resultsTarget.classList.add("hidden")
    this.commonSearchesTarget.classList.remove("hidden")
  }
  
  clearSearch() {
    this.inputTarget.value = ''
    this.hideResults()
  }
}
