import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "select", "submit", "error", "form", "success", "submitStatus"];
  
  connect() {
    // Initialize form validation state
    this.formIsValid = false;
    this.fieldStates = {};
    
    // Add animation classes when form is visible
    if (this.element) {
      setTimeout(() => {
        this.element.classList.add("animate-fade-in");
      }, 300);
    }
    
    // Check if we should show success message (e.g., after redirect)
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('success') === 'true') {
      this.showSuccessMessage();
      this.trackEvent('form_submission_success');
    }
    
    // Set a timestamp for the last time contact page was viewed
    localStorage.setItem('lastContactPageView', new Date().toISOString());
    
    // Restore any previously started form data for returning users
    this.restoreFormData();
    
    // Add event listeners to save form data as it's being filled
    this.element.querySelectorAll('input, textarea, select').forEach(field => {
      if (!['submit', 'checkbox', 'radio'].includes(field.type)) {
        field.addEventListener('change', () => {
          this.saveFormData();
          this.trackEvent('form_field_changed', { field: field.name });
        });
        field.addEventListener('blur', () => this.saveFormData());
      }
    });
    
    // Track form view event
    this.trackEvent('contact_form_viewed');
  }
  
  // Save the current form state to localStorage
  saveFormData() {
    const formData = {};
    this.element.querySelectorAll('input, textarea, select').forEach(field => {
      if (!['submit', 'button', 'reset'].includes(field.type) && field.name) {
        if (field.type === 'checkbox' || field.type === 'radio') {
          formData[field.name] = field.checked;
        } else {
          formData[field.name] = field.value;
        }
      }
    });
    
    localStorage.setItem('contactFormData', JSON.stringify(formData));
  }
  
  // Restore saved form data from localStorage
  restoreFormData() {
    const savedData = localStorage.getItem('contactFormData');
    if (!savedData) return;
    
    try {
      const formData = JSON.parse(savedData);
      
      // Populate form fields with saved data
      this.element.querySelectorAll('input, textarea, select').forEach(field => {
        if (field.name && formData.hasOwnProperty(field.name)) {
          if (field.type === 'checkbox' || field.type === 'radio') {
            field.checked = formData[field.name];
          } else {
            field.value = formData[field.name];
          }
        }
      });
      
      // Add a notice that we've restored their data
      const form = this.element.querySelector('form');
      if (form) {
        const notice = document.createElement('div');
        notice.className = 'text-sm text-gray-600 mb-4 p-2 bg-blue-50 rounded-md flex items-center justify-between';
        notice.innerHTML = `
          <div>
            <i class="fas fa-info-circle text-blue-500 mr-2"></i>
            We've restored your previous information to save you time.
          </div>
          <button type="button" class="text-blue-700 hover:text-blue-800 text-xs font-medium" data-action="click->contact-form#clearSavedData">
            Clear
          </button>
        `;
        form.prepend(notice);
      }
    } catch (e) {
      console.error('Error restoring form data:', e);
      localStorage.removeItem('contactFormData');
    }
  }
  
  // Clear saved form data
  clearSavedData() {
    localStorage.removeItem('contactFormData');
    this.element.querySelector('form').reset();
    
    // Remove the notice
    const notice = this.element.querySelector('.bg-blue-50');
    if (notice) {
      notice.remove();
    }
    
    // Track event
    this.trackEvent('form_data_cleared');
    
    // Set focus to first input field for accessibility
    const firstInput = this.element.querySelector('form input:not([type="hidden"]):not([type="submit"])');
    if (firstInput) {
      firstInput.focus();
    }
  }
  
  // Show success message when form is submitted successfully
  showSuccessMessage() {
    const formElement = this.element.querySelector('form');
    if (formElement) {
      // Hide the form
      formElement.style.display = 'none';
      
      // Create and show success message
      const successMessage = document.createElement('div');
      successMessage.className = 'bg-green-50 border border-green-100 rounded-xl p-8 text-center animate-fade-in';
      successMessage.setAttribute('role', 'status');
      successMessage.setAttribute('aria-live', 'polite');
      successMessage.innerHTML = `
        <div class="w-16 h-16 bg-green-100 rounded-full mx-auto mb-6 flex items-center justify-center">
          <i class="fas fa-check text-green-600 text-2xl" aria-hidden="true"></i>
        </div>
        <h3 class="text-2xl font-bold text-gray-900 mb-3">Message Sent Successfully!</h3>
        <p class="text-gray-600 mb-6">Thank you for reaching out. Our team will get back to you shortly.</p>
        <button type="button" class="px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2" data-action="click->contact-form#resetForm">
          Send Another Message
        </button>
      `;
      
      formElement.parentNode.appendChild(successMessage);
      
      // Update status for screen readers
      this.updateSubmitStatus('Form submitted successfully');
    }
  }
  
  // Reset form to initial state
  resetForm() {
    const formElement = this.element.querySelector('form');
    const successMessage = this.element.querySelector('.animate-fade-in');
    
    if (formElement && successMessage) {
      // Remove success message
      successMessage.remove();
      
      // Show and reset form
      formElement.style.display = 'block';
      formElement.reset();
      
      // Reset any submit button state
      const submitButton = formElement.querySelector('input[type="submit"]');
      if (submitButton && submitButton.dataset.originalText) {
        submitButton.value = submitButton.dataset.originalText;
        submitButton.disabled = false;
        submitButton.removeAttribute('aria-disabled');
        submitButton.classList.remove("opacity-75");
      }
      
      // Update status for screen readers
      this.updateSubmitStatus('Form ready for new submission');
      
      // Track form reset event
      this.trackEvent('form_reset');
      
      // Set focus to first input field for accessibility
      const firstInput = formElement.querySelector('input:not([type="hidden"]):not([type="submit"])');
      if (firstInput) {
        firstInput.focus();
      }
    }
  }

  // Validates the form upon submission
  validateForm(event) {
    // Prevent form submission if we need to validate client-side
    event.preventDefault();
    
    let isValid = true;
    const requiredFields = ["first_name", "email"];
    
    // Check each required field
    requiredFields.forEach(field => {
      const input = this.element.querySelector(`[name="${field}"]`);
      if (!input || !input.value.trim()) {
        this.showFieldError(input, "This field is required");
        isValid = false;
      } else {
        this.clearFieldError(input);
      }
    });
    
    // Email validation
    const emailInput = this.element.querySelector('[name="email"]');
    if (emailInput && emailInput.value.trim()) {
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailPattern.test(emailInput.value)) {
        this.showFieldError(emailInput, "Please enter a valid email address");
        isValid = false;
      }
    }
    
    // Track validation attempt
    this.trackEvent('form_validation_attempted', { isValid: isValid });
    
    // If valid, submit the form with loading state
    if (isValid) {
      this.formIsValid = true;
      this.showLoading();
      this.updateSubmitStatus('Submitting form...');
      
      // Submit the form after a slight delay to show the loading state
      setTimeout(() => {
        this.element.querySelector('form').submit();
      }, 500);
    } else {
      // Focus on first error field for accessibility
      const firstError = this.element.querySelector('.border-red-500');
      if (firstError) {
        firstError.focus();
      }
      
      this.updateSubmitStatus('Please correct the errors in the form');
    }
  }
  
  // Show loading state on submit button
  showLoading() {
    const submitBtn = this.element.querySelector('input[type="submit"]');
    if (submitBtn) {
      // Save original text
      submitBtn.dataset.originalText = submitBtn.value;
      
      // Replace with loading text and disable button
      submitBtn.value = "Sending...";
      submitBtn.disabled = true;
      submitBtn.setAttribute('aria-disabled', 'true');
      
      // Add a loading spinner
      submitBtn.classList.add("opacity-75");
      
      // Create and add a loading spinner element before the submit button
      const spinnerContainer = document.createElement("div");
      spinnerContainer.className = "absolute inset-y-0 right-4 flex items-center";
      spinnerContainer.innerHTML = '<div class="animate-spin h-4 w-4 border-2 border-white border-t-transparent rounded-full" aria-hidden="true"></div>';
      
      submitBtn.parentNode.style.position = "relative";
      submitBtn.parentNode.appendChild(spinnerContainer);
    }
  }
  
  // Update status message for screen readers
  updateSubmitStatus(message) {
    if (this.hasSubmitStatusTarget) {
      this.submitStatusTarget.textContent = message;
    }
  }
  
  // Display field-specific error
  showFieldError(field, message) {
    field.classList.add("border-red-500", "focus:ring-red-500");
    field.setAttribute('aria-invalid', 'true');
    
    // Create or update error message
    let errorDiv = field.parentNode.querySelector(".error-message");
    if (!errorDiv) {
      errorDiv = document.createElement("div");
      errorDiv.className = "error-message text-red-500 text-sm mt-1";
      errorDiv.setAttribute('role', 'alert');
      field.parentNode.appendChild(errorDiv);
    }
    errorDiv.textContent = message;
    
    // Link error to field for screen readers
    const errorId = `${field.name}-error`;
    errorDiv.id = errorId;
    field.setAttribute('aria-describedby', errorId);
  }
  
  // Clear field-specific error
  clearFieldError(field) {
    field.classList.remove("border-red-500", "focus:ring-red-500");
    field.removeAttribute('aria-invalid');
    field.removeAttribute('aria-describedby');
    
    // Remove error message if it exists
    const errorDiv = field.parentNode.querySelector(".error-message");
    if (errorDiv) {
      errorDiv.remove();
    }
  }
  
  // Handle field blur for real-time validation
  validateField(event) {
    const field = event.target;
    const name = field.getAttribute("name");
    const value = field.value.trim();
    
    // Skip validation for non-required fields that are empty
    if (!["first_name", "email"].includes(name) && !value) {
      this.clearFieldError(field);
      return;
    }
    
    switch (name) {
      case "first_name":
        if (!value) {
          this.showFieldError(field, "First name is required");
        } else {
          this.clearFieldError(field);
        }
        break;
        
      case "email":
        if (!value) {
          this.showFieldError(field, "Email is required");
        } else {
          const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          if (!emailPattern.test(value)) {
            this.showFieldError(field, "Please enter a valid email address");
          } else {
            this.clearFieldError(field);
          }
        }
        break;
        
      case "phone":
        if (value) {
          const phonePattern = /^[+]?[(]?[0-9]{3}[)]?[-\s.]?[0-9]{3}[-\s.]?[0-9]{4,6}$/;
          if (!phonePattern.test(value)) {
            this.showFieldError(field, "Please enter a valid phone number");
          } else {
            this.clearFieldError(field);
          }
        }
        break;
    }
    
    // Track field validation
    this.trackEvent('form_field_validated', { field: name, isValid: !field.classList.contains('border-red-500') });
  }
  
  // Track events for analytics
  trackEvent(name, params = {}) {
    // Add timestamp to all events
    const eventData = {
      ...params,
      timestamp: new Date().toISOString(),
      page: 'contact'
    };
    
    // Store events in localStorage for now (you can replace with your analytics service)
    const events = JSON.parse(localStorage.getItem('contactFormEvents') || '[]');
    events.push({ name, data: eventData });
    localStorage.setItem('contactFormEvents', JSON.stringify(events));
    
    // Example: Google Analytics 4 integration
    if (typeof gtag !== 'undefined') {
      gtag('event', name, eventData);
    }
    
    // Example: Facebook Pixel integration
    if (typeof fbq !== 'undefined') {
      fbq('track', name, eventData);
    }
    
    // Console log for development
    console.log(`Analytics Event: ${name}`, eventData);
  }
}
