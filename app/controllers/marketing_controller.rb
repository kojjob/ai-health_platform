class MarketingController < ApplicationController
  # Skip CSRF protection only for newsletter subscription to allow external form submissions
  skip_before_action :verify_authenticity_token, only: [ :newsletter_subscription ]

  layout "marketing"

  def home
    @testimonials = load_testimonials
    @features = load_features
  end

  def about
    @team_members = load_team_members
    @milestones = load_milestones
  end

  def how_it_works
    # @process_steps = load_process_steps
  end

  def features
    @feature_categories = load_feature_categories
  end

  def pricing
    @pricing_plans = load_pricing_plans
    @feature_comparison = load_feature_comparison
    @pricing_faqs = load_pricing_faqs
    @special_offers = [
      {
        title: "Healthcare Providers",
        description: "Special discounts for medical professionals and clinics",
        discount: "15% off any plan",
        code: "MEDPRO15"
      },
      {
        title: "Non-Profit Organizations",
        description: "Supporting healthcare non-profits and community organizations",
        discount: "25% off Enterprise plan",
        code: "NONPROFIT25"
      },
      {
        title: "Students",
        description: "Accessible healthcare for medical and healthcare students",
        discount: "30% off Basic plan",
        code: "STUDENT30"
      }
    ]
  end

  def contact
    if request.post?
      # Save inquiry details
      @inquiry = save_contact_inquiry(contact_params)

      # Send email notification
      ContactFormMailer.new_inquiry(contact_params).deliver_later

      # Redirect with success parameter for frontend handling
      redirect_to contact_path(success: true), notice: "Thank you for your message. We'll be in touch soon!"
    else
      # Initialize frequently asked questions for the view
      @faqs = load_contact_faqs
    end
  end

  def newsletter_subscription
    begin
      # Validate newsletter parameters
      email = newsletter_params[:email]
      name = newsletter_params[:name]

      if email.blank?
        render json: { success: false, message: "Email address is required." }, status: :bad_request
        return
      end

      # In a real application, you would save to a newsletter service like Mailchimp, ConvertKit, etc.
      # For now, we'll simulate saving to database and sending confirmation
      newsletter_data = {
        email: email,
        name: name,
        subscribed_at: Time.current,
        source: "contact_page",
        status: "active"
      }

      # Simulate saving newsletter subscription
      save_newsletter_subscription(newsletter_data)

      # Send welcome email (in real app, this would be handled by your email service)
      # NewsletterMailer.welcome_email(newsletter_data).deliver_later

      render json: {
        success: true,
        message: "Thank you for subscribing! You'll receive our latest health insights and updates."
      }, status: :ok

    rescue StandardError => e
      Rails.logger.error "Newsletter subscription error: #{e.message}"
      render json: {
        success: false,
        message: "Sorry, there was an error processing your subscription. Please try again."
      }, status: :internal_server_error
    end
  end

  def security
    @compliance_certifications = load_compliance_certifications
  end

  def help_center
    @help_categories = load_help_categories
    @popular_articles = load_popular_articles
  end

  def help_search
    query = params[:query].to_s.downcase
    articles = load_help_articles

    if query.present?
      filtered_articles = articles.select do |article|
        article[:title].downcase.include?(query) ||
        article[:category].downcase.include?(query) ||
        article[:content].to_s.downcase.include?(query)
      end
    else
      filtered_articles = []
    end

    render json: filtered_articles
  end

  def api_docs
    @api_versions = load_api_versions
    @api_endpoints = load_api_endpoints
  end

  def faq
    @faqs = load_faqs
  end

  def status
    @system_status = load_system_status
    @incident_history = load_incident_history
  end

  def community
    @community_forums = load_community_forums
    @featured_discussions = load_featured_discussions
  end

  def webinars
    @upcoming_webinars = load_upcoming_webinars
    @featured_webinars = load_featured_webinars
    @webinar_categories = load_webinar_categories
    @past_webinars = load_past_webinars
  end

  def privacy
    # Privacy Policy content is rendered from the view
  end

  def terms
    # Terms of Service content is rendered from the view
  end

  def hipaa_compliance
    # HIPAA Compliance information is rendered from the view
  end

  def cookie_policy
    # Cookie Policy content is rendered from the view
  end

  def accessibility
    # Accessibility Statement content is rendered from the view
  end

  def system_status
    # In a real implementation, this would fetch live status data from monitoring systems
    # For this demo, we're simulating real-time data
    status_data = load_system_status
    render json: status_data
  end

  private

  def load_help_categories
    [
      { name: "Getting Started", icon: "rocket", path: "#getting-started", article_count: 12 },
      { name: "Account Management", icon: "user-circle", path: "#account", article_count: 8 },
      { name: "Consultations", icon: "stethoscope", path: "#consultations", article_count: 15 },
      { name: "Billing & Insurance", icon: "credit-card", path: "#billing", article_count: 10 },
      { name: "Technical Support", icon: "laptop-code", path: "#technical", article_count: 6 },
      { name: "Privacy & Security", icon: "shield-alt", path: "#privacy", article_count: 9 }
    ]
  end

  def load_popular_articles
    [
      { title: "How to set up your MedGemma Health account", path: "#", views: 8432 },
      { title: "Connecting your insurance information", path: "#", views: 7256 },
      { title: "Troubleshooting video consultation issues", path: "#", views: 6891 },
      { title: "Understanding your diagnosis report", path: "#", views: 5743 },
      { title: "Uploading medical images properly", path: "#", views: 4982 }
    ]
  end

  def load_api_versions
    [
      { version: "v2", status: "current", release_date: "April 15, 2025" },
      { version: "v1", status: "legacy", release_date: "September 10, 2024", sunset_date: "October 1, 2025" }
    ]
  end

  def load_api_endpoints
    [
      { name: "Authentication", description: "OAuth 2.0 authentication endpoints", path: "#auth" },
      { name: "Patients", description: "Patient profile and medical record endpoints", path: "#patients" },
      { name: "Consultations", description: "Manage virtual consultations and appointments", path: "#consultations" },
      { name: "Diagnostic", description: "AI diagnostic analysis endpoints", path: "#diagnostic" },
      { name: "Prescriptions", description: "E-prescription management", path: "#prescriptions" },
      { name: "Webhooks", description: "Event notification system", path: "#webhooks" }
    ]
  end

  def load_system_status
    {
      overall: "operational",
      last_updated: Time.now,
      components: [
        { name: "API", status: "operational", uptime: "99.99%" },
        { name: "Web Application", status: "operational", uptime: "99.98%" },
        { name: "Mobile Applications", status: "operational", uptime: "99.97%" },
        { name: "Video Consultations", status: "operational", uptime: "99.95%" },
        { name: "AI Diagnosis System", status: "operational", uptime: "99.99%" },
        { name: "Database Services", status: "operational", uptime: "100%" }
      ]
    }
  end

  def load_incident_history
    [
      {
        date: 15.days.ago,
        title: "Video Service Degradation",
        description: "Some users experienced delayed video connections during consultations.",
        duration: "42 minutes",
        resolution: "Load balancer configuration updated to handle increased traffic."
      },
      {
        date: 2.months.ago,
        title: "Scheduled Maintenance",
        description: "Planned database upgrade to improve performance.",
        duration: "120 minutes",
        resolution: "Completed successfully with improved query response times."
      }
    ]
  end

  def load_community_forums
    [
      { name: "Patient Discussion", icon: "users", topic_count: 1243, member_count: 5280 },
      { name: "Healthcare Providers", icon: "user-md", topic_count: 768, member_count: 1435 },
      { name: "Feature Requests", icon: "lightbulb", topic_count: 524, member_count: 3192 },
      { name: "Research & Studies", icon: "microscope", topic_count: 321, member_count: 890 }
    ]
  end

  def load_featured_discussions
    [
      {
        title: "How MedGemma helped me get a quick diagnosis for my skin condition",
        author: "JenniferT",
        avatar_url: "https://randomuser.me/api/portraits/women/32.jpg",
        reply_count: 28,
        view_count: 1423,
        date: 3.days.ago
      },
      {
        title: "Best practices for uploading clear medical images",
        author: "Dr_Thompson",
        avatar_url: "https://randomuser.me/api/portraits/men/41.jpg",
        reply_count: 46,
        view_count: 2751,
        date: 5.days.ago
      },
      {
        title: "Feature request: Family account management",
        author: "RobertJ",
        avatar_url: "https://randomuser.me/api/portraits/men/22.jpg",
        reply_count: 63,
        view_count: 1892,
        date: 1.week.ago
      }
    ]
  end

  def load_upcoming_webinars
    [
      {
        id: 1,
        title: "AI in Healthcare Diagnostics: The Future is Now",
        description: "Discover how MedGemma's cutting-edge AI is revolutionizing diagnostic accuracy and speed. Join our lead researchers for live demos and Q&A.",
        presenter: "Dr. Sarah Chen, Chief Medical Officer",
        date: Date.parse("2025-05-28"),
        time: "2:00 PM - 3:30 PM EDT",
        duration: "90 minutes",
        category: "AI & Technology",
        level: "Beginner",
        max_attendees: 500,
        registered_count: 423,
        image: "webinars/ai-diagnostics.jpg",
        featured: true,
        tags: [ "AI", "Diagnostics", "Research" ],
        price: "Free",
        status: "upcoming"
      },
      {
        id: 2,
        title: "Building with the MedGemma API",
        description: "A comprehensive hands-on workshop for developers looking to integrate healthcare AI solutions. Includes code examples and best practices.",
        presenter: "Mark Johnson, Lead Developer",
        date: Date.parse("2025-06-05"),
        time: "11:00 AM - 2:00 PM PST",
        duration: "3 hours",
        category: "Development",
        level: "Intermediate",
        max_attendees: 100,
        registered_count: 76,
        image: "webinars/api-workshop.jpg",
        featured: false,
        tags: [ "API", "Development", "Integration" ],
        price: "$99",
        status: "upcoming"
      },
      {
        id: 3,
        title: "Healthcare Leaders Monthly Roundtable",
        description: "Exclusive monthly discussions for healthcare executives, CIOs, and innovation leaders to share insights and discuss industry trends.",
        presenter: "Dr. Michael Roberts, Healthcare Innovation",
        date: Date.parse("2025-06-15"),
        time: "11:00 AM - 12:00 PM PST",
        duration: "60 minutes",
        category: "Leadership",
        level: "Executive",
        max_attendees: 50,
        registered_count: 34,
        image: "webinars/leadership-roundtable.jpg",
        featured: false,
        tags: [ "Leadership", "Strategy", "Innovation" ],
        price: "Premium Only",
        status: "upcoming"
      }
    ]
  end

  def load_featured_webinars
    [
      {
        id: 4,
        title: "MedGemma Features Deep Dive",
        description: "Weekly 30-minute focused sessions on specific MedGemma features. Perfect for busy professionals who want to maximize their platform usage.",
        presenter: "Product Team",
        date: "Every Friday",
        time: "1:00 PM - 1:30 PM EST",
        duration: "30 minutes",
        category: "Training",
        level: "All Levels",
        recurring: true,
        image: "webinars/features-deep-dive.jpg",
        tags: [ "Features", "Training", "Weekly" ],
        price: "Free",
        status: "recurring"
      },
      {
        id: 5,
        title: "Patient Experience Forum: Success Stories",
        description: "Join fellow patients and care providers to share experiences, celebrate success stories, and discuss improvement ideas for better healthcare outcomes.",
        presenter: "Maria Santos, Patient Advocate",
        date: "Monthly",
        time: "7:00 PM - 8:30 PM EST",
        duration: "90 minutes",
        category: "Patient Care",
        level: "All Levels",
        recurring: true,
        image: "webinars/patient-forum.jpg",
        tags: [ "Patient Stories", "Community", "Support" ],
        price: "Free",
        status: "recurring"
      }
    ]
  end

  def load_webinar_categories
    [
      { name: "AI & Technology", count: 15, color: "blue" },
      { name: "Patient Care", count: 12, color: "green" },
      { name: "Development", count: 8, color: "purple" },
      { name: "Leadership", count: 6, color: "indigo" },
      { name: "Training", count: 10, color: "orange" },
      { name: "Research", count: 7, color: "teal" }
    ]
  end

  def load_past_webinars
    [
      {
        id: 6,
        title: "Introduction to AI-Powered Healthcare",
        description: "An overview of how artificial intelligence is transforming modern healthcare delivery and patient outcomes.",
        presenter: "Dr. Sarah Chen, Chief Medical Officer",
        date: Date.parse("2025-04-15"),
        time: "2:00 PM - 3:30 PM EDT",
        duration: "90 minutes",
        category: "AI & Technology",
        level: "Beginner",
        attendees_count: 487,
        recording_available: true,
        rating: 4.8,
        image: "webinars/intro-ai-healthcare.jpg",
        tags: [ "AI", "Introduction", "Healthcare" ],
        status: "completed"
      },
      {
        id: 7,
        title: "Telemedicine Best Practices",
        description: "Learn the best practices for conducting effective virtual consultations and improving patient engagement.",
        presenter: "Dr. Lisa Wang, Telemedicine Specialist",
        date: Date.parse("2025-03-20"),
        time: "1:00 PM - 2:00 PM PST",
        duration: "60 minutes",
        category: "Patient Care",
        level: "Intermediate",
        attendees_count: 312,
        recording_available: true,
        rating: 4.7,
        image: "webinars/telemedicine-best-practices.jpg",
        tags: [ "Telemedicine", "Best Practices", "Virtual Care" ],
        status: "completed"
      },
      {
        id: 8,
        title: "Healthcare Data Security and HIPAA Compliance",
        description: "Essential knowledge about protecting patient data and maintaining HIPAA compliance in digital healthcare.",
        presenter: "John Davis, Security Officer",
        date: Date.parse("2025-02-28"),
        time: "10:00 AM - 11:30 AM EST",
        duration: "90 minutes",
        category: "Security",
        level: "All Levels",
        attendees_count: 256,
        recording_available: true,
        rating: 4.9,
        image: "webinars/hipaa-compliance.jpg",
        tags: [ "Security", "HIPAA", "Compliance" ],
        status: "completed"
      }
    ]
  end

  def load_feature_categories
    [
      {
        name: "AI-Powered Diagnostics",
        icon: "fa-brain",
        description: "Advanced artificial intelligence for accurate medical diagnosis",
        features: [
          {
            title: "Symptom Analysis",
            description: "Advanced AI algorithms analyze symptoms and medical images for accurate diagnosis",
            icon: "fa-stethoscope"
          },
          {
            title: "Image Recognition",
            description: "State-of-the-art medical image analysis for skin conditions, x-rays, and more",
            icon: "fa-image"
          },
          {
            title: "Real-time Learning",
            description: "Our AI continuously learns and improves from verified doctor diagnoses",
            icon: "fa-chart-line"
          }
        ]
      },
      {
        name: "Virtual Consultations",
        icon: "fa-video",
        description: "Connect with healthcare providers from anywhere",
        features: [
          {
            title: "24/7 Availability",
            description: "Access medical professionals around the clock for urgent care needs",
            icon: "fa-clock"
          },
          {
            title: "Secure Video Calls",
            description: "HIPAA-compliant video consultations with verified doctors",
            icon: "fa-shield-alt"
          },
          {
            title: "Multi-specialty Access",
            description: "Connect with specialists across various medical fields",
            icon: "fa-user-md"
          }
        ]
      },
      {
        name: "Patient Care",
        icon: "fa-heart",
        description: "Comprehensive care management tools",
        features: [
          {
            title: "Digital Health Records",
            description: "Secure storage and access to your complete medical history",
            icon: "fa-folder-open"
          },
          {
            title: "Medication Tracking",
            description: "Smart medication reminders and interaction warnings",
            icon: "fa-pills"
          },
          {
            title: "Treatment Plans",
            description: "Personalized care plans with progress tracking",
            icon: "fa-clipboard-check"
          }
        ]
      },
      {
        name: "Emergency Services",
        icon: "fa-ambulance",
        description: "Quick access to emergency care",
        features: [
          {
            title: "Urgent Care Triage",
            description: "AI-powered severity assessment for immediate care needs",
            icon: "fa-first-aid"
          },
          {
            title: "Emergency Contacts",
            description: "One-click access to emergency services and trusted contacts",
            icon: "fa-phone-alt"
          },
          {
            title: "Location Services",
            description: "Automatic location sharing with emergency responders",
            icon: "fa-map-marker-alt"
          }
        ]
      }
    ]
  end

  def load_testimonials
    [
      {
        name: "Dr. Sarah Johnson",
        role: "Emergency Medicine Physician",
        hospital: "Metro General Hospital",
        content: "MedGemma has revolutionized how I approach diagnosis. The AI-powered insights have helped me catch conditions I might have missed, especially during busy night shifts.",
        rating: 5,
        avatar: "https://randomuser.me/api/portraits/women/44.jpg",
        verified: true
      },
      {
        name: "Maria Rodriguez",
        role: "Patient",
        location: "Austin, TX",
        content: "As someone living in a rural area, MedGemma has been a lifesaver. I can get expert medical opinions without traveling hours to the city.",
        rating: 5,
        avatar: "https://randomuser.me/api/portraits/women/32.jpg",
        verified: true
      },
      {
        name: "Dr. Michael Chen",
        role: "Dermatologist",
        hospital: "University Medical Center",
        content: "The skin condition analysis feature is incredibly accurate. It's become an essential tool in my practice for preliminary assessments.",
        rating: 5,
        avatar: "https://randomuser.me/api/portraits/men/22.jpg",
        verified: true
      }
    ]
  end

  def load_features
    [
      {
        title: "AI-Powered Diagnosis",
        description: "Advanced machine learning algorithms analyze symptoms and medical images for accurate preliminary diagnosis.",
        icon: "fa-brain",
        category: "core"
      },
      {
        title: "24/7 Virtual Consultations",
        description: "Connect with licensed healthcare providers anytime, anywhere through secure video consultations.",
        icon: "fa-video",
        category: "core"
      },
      {
        title: "Secure Health Records",
        description: "HIPAA-compliant storage and management of your complete medical history and records.",
        icon: "fa-shield-alt",
        category: "security"
      },
      {
        title: "Prescription Management",
        description: "Digital prescription management with pharmacy integration and medication reminders.",
        icon: "fa-pills",
        category: "management"
      }
    ]
  end

  def load_team_members
    [
      {
        name: "Dr. Sarah Chen",
        role: "Chief Medical Officer",
        bio: "Leading medical AI researcher with 15+ years experience in emergency medicine and digital health innovation.",
        image: "team/dr-sarah-chen.jpg",
        linkedin: "https://linkedin.com/in/sarahchen",
        specialties: [ "Emergency Medicine", "AI Diagnostics", "Digital Health" ]
      },
      {
        name: "Mark Johnson",
        role: "Chief Technology Officer",
        bio: "Former Google engineer specializing in machine learning and healthcare technology infrastructure.",
        image: "team/mark-johnson.jpg",
        linkedin: "https://linkedin.com/in/markjohnson",
        specialties: [ "Machine Learning", "Cloud Architecture", "Healthcare APIs" ]
      },
      {
        name: "Dr. Lisa Wang",
        role: "Head of Research",
        bio: "PhD in Biomedical Informatics from Stanford, leading our AI research and clinical validation studies.",
        image: "team/dr-lisa-wang.jpg",
        linkedin: "https://linkedin.com/in/lisawang",
        specialties: [ "Biomedical Informatics", "Clinical Research", "AI Ethics" ]
      }
    ]
  end

  def load_milestones
    [
      { year: "2023", title: "MedGemma Founded", description: "Started with a vision to democratize healthcare through AI" },
      { year: "2024", title: "AI Model Launch", description: "Released our first AI diagnostic model with 95% accuracy" },
      { year: "2024", title: "10K+ Patients", description: "Reached milestone of serving over 10,000 patients" },
      { year: "2025", title: "Global Expansion", description: "Expanding to serve patients in 50+ countries worldwide" }
    ]
  end

  def load_contact_faqs
    [
      {
        question: "How quickly will I receive a response?",
        answer: "We typically respond to all inquiries within 24 hours during business days."
      },
      {
        question: "Do you offer technical support?",
        answer: "Yes! Our technical support team is available 24/7 for urgent issues."
      },
      {
        question: "Can I schedule a demo?",
        answer: "Absolutely! Contact us to schedule a personalized demo of our platform."
      }
    ]
  end

  def load_pricing_plans
    [
      {
        name: "Basic",
        price: 29,
        period: "month",
        description: "Perfect for individuals and small practices",
        features: [ "AI-powered consultations", "Basic health monitoring", "Mobile app access", "Email support" ],
        testimonial: {
          content: "MedGemma Basic has been perfect for my personal health monitoring. The AI insights are incredibly helpful.",
          author: "Sarah Johnson",
          role: "Patient",
          avatar: "testimonials/sarah-johnson.jpg"
        }
      },
      {
        name: "Professional",
        price: 99,
        period: "month",
        description: "Ideal for healthcare providers and clinics",
        features: [ "Everything in Basic", "Advanced diagnostics", "API access", "Priority support", "Team collaboration" ],
        testimonial: {
          content: "The Professional plan has transformed our clinic's efficiency. The API integration is seamless.",
          author: "Dr. Michael Chen",
          role: "Family Medicine",
          avatar: "testimonials/dr-michael-chen.jpg"
        }
      },
      {
        name: "Enterprise",
        price: 299,
        period: "month",
        description: "For large healthcare organizations",
        features: [ "Everything in Professional", "Custom integrations", "Dedicated support", "Advanced analytics", "HIPAA compliance" ],
        testimonial: {
          content: "MedGemma Enterprise has scaled perfectly with our hospital network. Outstanding support and reliability.",
          author: "Dr. Lisa Wang",
          role: "CTO, Metro Health",
          avatar: "testimonials/dr-lisa-wang.jpg"
        }
      }
    ]
  end

  def load_feature_comparison
    [
      {
        category: "Core Features",
        features: [
          {
            name: "AI Consultations",
            description: "AI-powered health consultations and diagnostics",
            basic: true,
            professional: true,
            enterprise: true
          },
          {
            name: "Mobile App",
            description: "Full-featured mobile application",
            basic: true,
            professional: true,
            enterprise: true
          },
          {
            name: "24/7 Support",
            description: "Round-the-clock customer support",
            basic: false,
            professional: true,
            enterprise: true
          }
        ]
      },
      {
        category: "Advanced Features",
        features: [
          {
            name: "API Access",
            description: "Full REST API access for integrations",
            basic: false,
            professional: true,
            enterprise: true
          },
          {
            name: "Advanced Analytics",
            description: "Detailed reporting and analytics dashboard",
            basic: false,
            professional: false,
            enterprise: true
          },
          {
            name: "Custom Integrations",
            description: "Custom API integrations and webhooks",
            basic: false,
            professional: false,
            enterprise: true
          }
        ]
      }
    ]
  end

  def load_pricing_faqs
    [
      {
        question: "Can I change my plan anytime?",
        answer: "Yes, you can upgrade or downgrade your plan at any time. Changes take effect immediately."
      },
      {
        question: "Is there a free trial?",
        answer: "Yes! We offer a 14-day free trial with full access to all Basic plan features."
      },
      {
        question: "What payment methods do you accept?",
        answer: "We accept all major credit cards, PayPal, and can arrange invoicing for Enterprise customers."
      }
    ]
  end

  def save_contact_inquiry(params)
    # In a real application, you would save this to a database
    # For now, we'll just log it and return a simulated response
    Rails.logger.info "Contact inquiry received: #{params.inspect}"
    { id: rand(1000..9999), submitted_at: Time.current, status: "received" }
  end

  def save_newsletter_subscription(data)
    # In a real application, you would save this to a database or external service
    Rails.logger.info "Newsletter subscription: #{data.inspect}"
    true
  end

  def contact_params
    params.permit(:name, :email, :subject, :message, :company, :phone)
  end

  def newsletter_params
    params.permit(:email, :name)
  end

  def load_compliance_certifications
    [
      {
        name: "HIPAA Compliance",
        description: "Health Insurance Portability and Accountability Act compliance for patient data protection",
        icon: "fa-shield-alt",
        status: "certified",
        certificate_url: "#hipaa-cert"
      },
      {
        name: "SOC 2 Type II",
        description: "Service Organization Control 2 certification for security, availability, and confidentiality",
        icon: "fa-certificate",
        status: "certified",
        certificate_url: "#soc2-cert"
      },
      {
        name: "ISO 27001",
        description: "International standard for information security management systems",
        icon: "fa-lock",
        status: "certified",
        certificate_url: "#iso27001-cert"
      },
      {
        name: "GDPR Compliance",
        description: "General Data Protection Regulation compliance for EU data protection",
        icon: "fa-user-shield",
        status: "certified",
        certificate_url: "#gdpr-cert"
      }
    ]
  end
end
