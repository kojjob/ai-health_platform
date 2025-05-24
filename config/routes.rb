Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "marketing#home"
  
  # Marketing pages
  get "about", to: "marketing#about", as: :about
  get "how-it-works", to: "marketing#how_it_works", as: :how_it_works
  get "features", to: "marketing#features", as: :features
  get "pricing", to: "marketing#pricing", as: :pricing
  get "contact", to: "marketing#contact", as: :contact
  post "contact", to: "marketing#process_contact", as: :process_contact
  
  # Legal pages
  get "privacy", to: "marketing#privacy", as: :privacy
  get "terms", to: "marketing#terms", as: :terms
  get "security", to: "marketing#security", as: :security
  get "hipaa-compliance", to: "marketing#hipaa_compliance", as: :hipaa_compliance
  get "accessibility", to: "marketing#accessibility", as: :accessibility
  get "cookie-policy", to: "marketing#cookie_policy", as: :cookie_policy
  
  # Resources pages
  get "blog", to: "marketing#blog", as: :blog
  get "help-center", to: "marketing#help_center", as: :help_center
  get "api-docs", to: "marketing#api_docs", as: :api_docs
  get "webinars", to: "marketing#webinars", as: :webinars
  get "system-status", to: "marketing#status", as: :system_status
  get "community", to: "marketing#community", as: :community
  
  # Solutions pages
  get "solutions/hospitals", to: "marketing#hospitals_solution", as: :hospitals_solution
  get "solutions/primary-care", to: "marketing#primary_care_solution", as: :primary_care_solution
  get "solutions/specialty-clinics", to: "marketing#specialty_clinics_solution", as: :specialty_clinics_solution
  get "solutions/telehealth-providers", to: "marketing#telehealth_providers_solution", as: :telehealth_providers_solution
  get "solutions/insurance", to: "marketing#insurance_solution", as: :insurance_solution
  get "case-studies", to: "marketing#case_studies", as: :case_studies
  
  # Feature detail pages
  scope "features" do
    get "symptom-checker", to: "marketing#symptom_checker_feature", as: :symptom_checker_feature
    get "telehealth", to: "marketing#telehealth_feature", as: :telehealth_feature
    get "health-records", to: "marketing#health_records_feature", as: :health_records_feature
    get "appointment-booking", to: "marketing#appointment_booking_feature", as: :appointment_booking_feature
    get "ai-diagnostics", to: "marketing#ai_diagnostics_feature", as: :ai_diagnostics_feature
    get "patient-management", to: "marketing#patient_management_feature", as: :patient_management_feature
    get "ehr-integration", to: "marketing#ehr_integration_feature", as: :ehr_integration_feature
    get "prescription-management", to: "marketing#prescription_management_feature", as: :prescription_management_feature
    get "health-analytics", to: "marketing#health_analytics_feature", as: :health_analytics_feature
    get "reporting", to: "marketing#reporting_feature", as: :reporting_feature
    get "benchmarking", to: "marketing#benchmarking_feature", as: :benchmarking_feature
    get "access-control", to: "marketing#access_control_feature", as: :access_control_feature
    get "hipaa-compliance", to: "marketing#hipaa_compliance_feature", as: :hipaa_compliance_feature
    get "encryption", to: "marketing#encryption_feature", as: :encryption_feature
    get "audit-logs", to: "marketing#audit_logs_feature", as: :audit_logs_feature
    get "api-access", to: "marketing#api_access_feature", as: :api_access_feature
    get "third-party", to: "marketing#third_party_feature", as: :third_party_feature
    get "fhir-support", to: "marketing#fhir_support_feature", as: :fhir_support_feature
    get "medical-imaging-ai", to: "marketing#medical_imaging_ai_feature", as: :medical_imaging_ai_feature
    get "nlp-processing", to: "marketing#nlp_processing_feature", as: :nlp_processing_feature
    get "clinical-decision", to: "marketing#clinical_decision_feature", as: :clinical_decision_feature
    get "quantum-analytics", to: "marketing#quantum_analytics_feature", as: :quantum_analytics_feature
  end
  
  # User account routes
  get "login", to: "devise/sessions#new", as: :login
  get "signup", to: "devise/registrations#new", as: :signup
  get "dashboard", to: "dashboard#index", as: :dashboard
  get "account/profile", to: "account#profile", as: :account_profile
  get "account/settings", to: "account#settings", as: :account_settings
  get "account/notifications", to: "account#notifications", as: :account_notifications
  get "help", to: "account#help", as: :help
  get "logout", to: "devise/sessions#destroy", as: :logout

  # All features page
  get "all-features", to: "marketing#all_features", as: :all_features
end
