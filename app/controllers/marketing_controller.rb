class MarketingController < ApplicationController

  layout 'marketing'

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
  
  def load_faqs
    [
      {
        question: "How does MedGemma Health's AI diagnosis work?",
        answer: "MedGemma Health uses advanced machine learning algorithms trained on millions of medical data points to analyze symptoms, medical history, and images. The AI compares your information with its extensive database to suggest possible diagnoses, which are then reviewed by qualified healthcare professionals for confirmation."
      },
      {
        question: "Is my medical data secure with MedGemma Health?",
        answer: "Absolutely. MedGemma Health complies with HIPAA regulations and employs end-to-end encryption for all patient data. Your information is stored in secure servers with multiple layers of protection, and we never share your data with third parties without your explicit consent."
      },
      {
        question: "Can I use insurance with MedGemma Health services?",
        answer: "Yes, MedGemma Health works with many major insurance providers. You can verify your coverage by entering your insurance information in your account settings. We also offer transparent self-pay options for those without coverage or who prefer not to use insurance."
      },
      {
        question: "How quickly can I get a consultation with a doctor?",
        answer: "Most patients can schedule a virtual consultation within 24-48 hours. For urgent issues, our on-demand service can connect you with a medical professional within 30 minutes during operating hours."
      },
      {
        question: "What medical conditions can MedGemma's AI help diagnose?",
        answer: "Our AI system is trained to recognize thousands of conditions across multiple specialties, including dermatology, primary care, and more. However, it serves as a diagnostic aid, not a replacement for professional medical evaluation, which is why all AI suggestions are reviewed by qualified healthcare providers."
      },
      {
        question: "How do I get started with MedGemma Health?",
        answer: "Getting started is easy! Simply create an account through our website or mobile app, complete your health profile, and you can immediately access our AI symptom checker or schedule your first consultation."
      }
    ]
  end
  
  def load_help_articles
    [
      { title: "How to set up your MedGemma Health account", path: "/help/getting-started/account-setup", category: "Getting Started", content: "Learn how to create and set up your MedGemma Health account in a few simple steps." },
      { title: "Managing your health profile", path: "/help/account/health-profile", category: "Account Management", content: "Keep your health profile updated for more accurate diagnoses and better healthcare recommendations." },
      { title: "Connecting your insurance information", path: "/help/billing/insurance", category: "Billing & Insurance", content: "Step-by-step guide to connecting and verifying your insurance information in your account." },
      { title: "How to schedule a virtual consultation", path: "/help/consultations/scheduling", category: "Consultations", content: "Learn how to book, reschedule, or cancel virtual consultations with healthcare providers." },
      { title: "Understanding your diagnosis report", path: "/help/technical/diagnosis-report", category: "Technical Support", content: "How to interpret the AI-generated diagnosis reports and medical recommendations." },
      { title: "Uploading medical images properly", path: "/help/technical/uploading-images", category: "Technical Support", content: "Best practices for uploading clear, usable medical images for accurate AI analysis." },
      { title: "How billing works", path: "/help/billing/billing-process", category: "Billing & Insurance", content: "Everything you need to know about our billing process, insurance claims, and payment options." },
      { title: "Secure data handling policies", path: "/help/privacy/data-policies", category: "Privacy & Security", content: "Learn how we protect your sensitive medical information and ensure HIPAA compliance." },
      { title: "Supported health insurance providers", path: "/help/billing/supported-insurance", category: "Billing & Insurance", content: "See the list of insurance providers we currently work with and how coverage works." },
      { title: "Sharing medical records with your doctor", path: "/help/privacy/sharing-records", category: "Privacy & Security", content: "How to securely share your MedGemma Health records with your existing healthcare providers." },
      { title: "Troubleshooting video consultation issues", path: "/help/technical/video-troubleshooting", category: "Technical Support", content: "Common video consultation problems and how to solve them quickly." },
      { title: "Setting up family member profiles", path: "/help/account/family-profiles", category: "Account Management", content: "How to add and manage family member profiles under your account." }
    ]
  end

  def contact_params
    params.permit(:first_name, :last_name, :email, :phone, :inquiry_type, :message, :subscribe)
  end

  def load_testimonials
    [
      {
        name: "Sarah Johnson",
        role: "Patient",
        content: "MedGemma diagnosed my skin condition accurately when three doctors couldn't. Amazing technology!",
        rating: 5,
        image: "testimonial-1.jpg"
      },
      {
        name: "Dr. Michael Chen",
        role: "Dermatologist",
        content: "The AI assistance helps me provide better care to more patients. It's like having a specialist colleague 24/7.",
        rating: 5,
        image: "testimonial-2.jpg"
      }
    ]
  end

  def load_features
    [
      {
        icon: "fa-robot",
        title: "AI-Powered Diagnosis",
        description: "Get instant analysis powered by Google's MedGemma",
        color: "blue"
      },
      {
        icon: "fa-video",
        title: "Virtual Consultations",
        description: "Connect with doctors anytime, anywhere",
        color: "green"
      },
      {
        icon: "fa-shield-virus",
        title: "Secure & Private",
        description: "HIPAA compliant with military-grade encryption",
        color: "purple"
      }
    ]
  end

  def load_team_members
    [
      {
        name: "Dr. Sarah Smith",
        role: "CEO & Co-founder",
        bio: "Former Chief of Digital Health at Mayo Clinic with 15+ years in healthcare innovation."
      },
      {
        name: "John Doe",
        role: "CTO & Co-founder",
        bio: "AI researcher and former Tech Lead at DeepMind Health."
      },
      {
        name: "Dr. Lisa Chen",
        role: "Chief Medical Officer",
        bio: "Board-certified physician with expertise in telemedicine and digital health."
      }
    ]
  end

  def load_milestones
    [
      {
        year: "2024",
        title: "Platform Launch",
        description: "MedGemma Health platform launched with core AI-powered diagnosis features."
      },
      {
        year: "2024",
        title: "First 10,000 Patients",
        description: "Reached milestone of helping 10,000 patients with AI-assisted diagnoses."
      },
      {
        year: "2024",
        title: "Doctor Network",
        description: "Expanded our network to over 1,000 verified healthcare providers."
      },
      {
        year: "2025",
        title: "Global Expansion",
        description: "Extended services to 30+ countries worldwide."
      },
      {
        year: "2025",
        title: "AI Enhancement",
        description: "Major upgrade to our AI diagnostic capabilities with 95% accuracy rate."
      }
    ]
  end

  def load_pricing_plans
    [
      {
        name: "Basic Care",
        monthly_price: 29,
        annual_price: 279,  # Save ~20%
        billing_period: "month",
        badge: nil,
        description: "Perfect for individuals seeking essential healthcare services",
        highlight: false,
        cta_text: "Start Free Trial",
        features: [
          "Up to 3 AI symptom checks per month",
          "24/7 access to medical resources",
          "Secure health record storage",
          "Email support",
          "Mobile app access"
        ],
        testimonial: {
          quote: "MedGemma's Basic plan has been perfect for my occasional health concerns. The AI check-ups are impressively accurate.",
          author: "Sarah J.",
          role: "Individual User",
          avatar: "marketing/testimonials/sarah.jpg"
        }
      },
      {
        name: "Professional",
        monthly_price: 79,
        annual_price: 759,  # Save ~20%
        billing_period: "month",
        badge: "Most Popular",
        description: "Ideal for families and frequent healthcare needs",
        highlight: true,
        cta_text: "Start Free Trial",
        features: [
          "Unlimited AI symptom checks",
          "Priority video consultations",
          "Family health tracking (up to 4 members)",
          "24/7 chat support",
          "Medication reminders",
          "Prescription management",
          "Annual health assessment"
        ],
        testimonial: {
          quote: "The family tracking features have been a game-changer. We can manage everyone's health in one place!",
          author: "David & Maria L.",
          role: "Family Plan",
          avatar: "marketing/testimonials/family.jpg"
        }
      },
      {
        name: "Enterprise",
        monthly_price: 199,
        annual_price: 1919,  # Save ~20%
        billing_period: "month",
        badge: "Custom Solutions",
        description: "Comprehensive solution for healthcare providers",
        highlight: false,
        cta_text: "Contact Sales",
        features: [
          "Full AI diagnostic suite",
          "Custom EMR integration",
          "Unlimited patient consultations",
          "Priority support 24/7",
          "Advanced analytics dashboard",
          "HIPAA compliance tools",
          "Custom branding options",
          "Staff training and support"
        ],
        testimonial: {
          quote: "MedGemma transformed our clinic workflow. The integration with our existing systems was seamless.",
          author: "Dr. Michael T.",
          role: "Cedar Medical Center",
          avatar: "marketing/testimonials/doctor.jpg"
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
            name: "AI Symptom Checks",
            description: "Advanced AI-powered symptom analysis and recommendations",
            basic: "3 per month",
            professional: "Unlimited",
            enterprise: "Unlimited + Custom Training"
          },
          {
            name: "Health Record Storage",
            description: "Secure storage for your medical records and history",
            basic: "5GB",
            professional: "25GB",
            enterprise: "Unlimited"
          },
          {
            name: "Mobile App Access",
            description: "Access on iOS and Android devices",
            basic: "Basic features",
            professional: "Full features",
            enterprise: "Full features + Custom branding"
          }
        ]
      },
      {
        category: "Support",
        features: [
          {
            name: "Customer Support",
            description: "Access to our support team",
            basic: "Email only",
            professional: "24/7 Chat",
            enterprise: "24/7 Priority Support"
          },
          {
            name: "Response Time",
            description: "Average time to first response",
            basic: "24 hours",
            professional: "4 hours",
            enterprise: "1 hour guaranteed"
          },
          {
            name: "Onboarding",
            description: "Help getting started with the platform",
            basic: "Self-serve",
            professional: "Guided setup",
            enterprise: "Dedicated specialist"
          }
        ]
      },
      {
        category: "Advanced Features",
        features: [
          {
            name: "Video Consultations",
            description: "Live video consultations with healthcare professionals",
            basic: "Not included",
            professional: "Priority access",
            enterprise: "Unlimited"
          },
          {
            name: "Family Management",
            description: "Manage multiple family members' health records",
            basic: "Not included",
            professional: "Up to 4 members",
            enterprise: "Unlimited"
          },
          {
            name: "EMR Integration",
            description: "Integration with existing Electronic Medical Record systems",
            basic: "Not included",
            professional: "Basic integration",
            enterprise: "Custom integration"
          },
          {
            name: "Analytics Dashboard",
            description: "Health insights and analytics",
            basic: "Basic insights",
            professional: "Enhanced dashboard",
            enterprise: "Advanced analytics"
          }
        ]
      }
    ]
  end

  def load_pricing_faqs
    [
      {
        question: "Can I switch plans at any time?",
        answer: "Yes, you can upgrade or downgrade your plan at any time. Changes will be reflected in your next billing cycle. Upgrading takes effect immediately, while downgrades will take effect at the end of your current billing period."
      },
      {
        question: "Is there a contract or commitment?",
        answer: "No long-term contracts required. All plans are month-to-month, and you can cancel anytime. For annual plans, you commit to 12 months of service paid upfront with a significant discount."
      },
      {
        question: "What payment methods do you accept?",
        answer: "We accept all major credit cards (Visa, Mastercard, American Express, Discover), debit cards, and HSA/FSA cards for payment. Enterprise customers can also pay by invoice."
      },
      {
        question: "Is my health data secure?",
        answer: "Yes, we are HIPAA compliant and use industry-leading encryption to protect your health information. All data is encrypted at rest and in transit, and we undergo regular security audits."
      },
      {
        question: "Do you offer refunds?",
        answer: "We offer a 30-day money-back guarantee for new customers. If you're not satisfied with our service, contact our support team within 30 days of your initial payment for a full refund."
      },
      {
        question: "How does the free trial work?",
        answer: "Our 14-day free trial gives you full access to all features of your selected plan. No credit card is required to start. At the end of your trial, you can choose to subscribe or your account will automatically downgrade to our limited free tier."
      },
      {
        question: "Are there any setup fees?",
        answer: "There are no setup fees for Basic and Professional plans. Enterprise plans may include one-time setup fees depending on customization requirements, which will be outlined in your custom quote."
      },
      {
        question: "Can I use MedGemma internationally?",
        answer: "Yes, MedGemma is available globally. However, some features like video consultations with healthcare providers may be limited to certain regions due to licensing requirements. The platform supports multiple languages and regional healthcare standards."
      }
    ]
  end

  def load_contact_faqs
    [
      {
        question: "How do I schedule a demo?", 
        answer: "You can schedule a demo through our contact form by selecting 'Schedule a Demo' as your inquiry type, or by calling our sales team directly at 1-800-MEDGEMMA."
      },
      {
        question: "Is my data secure with MedGemma Health?", 
        answer: "Yes! We follow HIPAA guidelines and employ military-grade encryption to ensure that your medical data remains private and secure."
      },
      {
        question: "Can I integrate MedGemma with my existing systems?", 
        answer: "Absolutely. Our platform offers API access and integrations with most major EMR systems and healthcare software providers."
      },
      {
        question: "What devices can I use MedGemma on?", 
        answer: "Our platform is accessible on desktops, tablets, and mobile phones, with native apps available for iOS and Android."
      },
      {
        question: "How quickly can I get started?", 
        answer: "Most customers can be fully onboarded within 48 hours of signing up. Our team will guide you through the entire process."
      },
      {
        question: "Do you offer training for my staff?", 
        answer: "Yes, we provide comprehensive training sessions and documentation to ensure your team can make the most of our platform."
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
end