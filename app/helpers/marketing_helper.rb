module MarketingHelper
  def marketing_image_tag(image_name, **options)
    # Try to use the actual image if it exists
    if asset_exists?(image_name)
      image_tag(image_name, **options)
    else
      # Create a placeholder div with a more modern gradient background and icon
      content_tag :div, class: "#{options[:class]} flex items-center justify-center bg-gradient-to-br from-gray-50 to-gray-100 relative overflow-hidden" do
        content = case image_name
        when "marketing/step-upload.png"
          content_tag :div, class: "text-center p-8 relative z-10" do
            concat content_tag(:div, nil, class: "absolute top-0 left-0 right-0 bottom-0 bg-gradient-to-br from-medgemma-50 to-blue-50 opacity-70 -z-10")
            concat content_tag(:div, nil, class: "absolute top-1/4 right-1/4 w-32 h-32 rounded-full bg-medgemma-100 animate-float-slow-reverse blur-lg")
            concat content_tag(:div, nil, class: "w-20 h-20 mx-auto bg-white rounded-full shadow-xl flex items-center justify-center mb-6")
            concat content_tag(:i, nil, class: "fas fa-cloud-upload-alt text-5xl text-medgemma-500")
            concat content_tag(:h3, "Secure Symptom Upload", class: "text-xl font-bold text-gray-800 mb-2")
            concat content_tag(:p, "Upload securely encrypted photos and symptoms for analysis", class: "text-gray-600")
            concat content_tag(:div, nil, class: "mt-4 grid grid-cols-3 gap-2")
            concat content_tag(:div, nil, class: "w-12 h-12 rounded-lg bg-blue-100 mx-auto flex items-center justify-center")
            concat content_tag(:i, nil, class: "fas fa-camera text-blue-600")
          end
        when "marketing/step-ai-analysis.png"
          content_tag :div, class: "text-center p-8 relative z-10" do
            concat content_tag(:div, nil, class: "absolute top-0 left-0 right-0 bottom-0 bg-gradient-to-br from-teal-50 to-blue-50 opacity-70 -z-10")
            concat content_tag(:div, nil, class: "absolute bottom-1/4 left-1/4 w-40 h-40 rounded-full bg-teal-100 animate-float-slow blur-lg")
            concat content_tag(:div, nil, class: "w-20 h-20 mx-auto bg-white rounded-full shadow-xl flex items-center justify-center mb-6")
            concat content_tag(:i, nil, class: "fas fa-microchip text-5xl text-teal-500")
            concat content_tag(:h3, "Advanced AI Analysis", class: "text-xl font-bold text-gray-800 mb-2")
            concat content_tag(:p, "Our AI provides accurate diagnosis in seconds with high confidence scores", class: "text-gray-600")
            # Add some abstract data visualization elements
            concat content_tag(:div, nil, class: "mt-4 w-3/4 mx-auto h-3 bg-teal-100 rounded-full overflow-hidden")
            concat content_tag(:div, nil, class: "h-full w-4/5 bg-gradient-to-r from-teal-400 to-blue-500 rounded-full")
          end
        when "marketing/step-consultation.png"
          content_tag :div, class: "text-center p-8 relative z-10" do
            concat content_tag(:div, nil, class: "absolute top-0 left-0 right-0 bottom-0 bg-gradient-to-br from-purple-50 to-pink-50 opacity-70 -z-10")
            concat content_tag(:div, nil, class: "absolute top-1/3 right-1/3 w-36 h-36 rounded-full bg-purple-100 animate-float-slow blur-lg")
            concat content_tag(:div, nil, class: "w-20 h-20 mx-auto bg-white rounded-full shadow-xl flex items-center justify-center mb-6")
            concat content_tag(:i, nil, class: "fas fa-user-md text-5xl text-purple-500")
            concat content_tag(:h3, "Expert Doctor Consultation", class: "text-xl font-bold text-gray-800 mb-2")
            concat content_tag(:p, "Connect with board-certified doctors for personalized care", class: "text-gray-600")
            # Add a doctor card mockup
            concat content_tag(:div, nil, class: "mt-6 bg-white rounded-lg shadow-md p-3 max-w-xs mx-auto flex items-center")
            concat content_tag(:div, nil, class: "w-12 h-12 rounded-full bg-purple-100 flex-shrink-0 flex items-center justify-center")
            concat content_tag(:i, nil, class: "fas fa-user-md text-purple-600")
            concat content_tag(:div, nil, class: "ml-3 text-left")
            concat content_tag(:div, "Dr. Sarah Johnson", class: "font-medium text-gray-900 text-sm")
            concat content_tag(:div, "Dermatology Specialist", class: "text-gray-500 text-xs")
          end
        else
          content_tag :div, class: "text-center p-8 relative z-10" do
            concat content_tag(:div, nil, class: "w-20 h-20 mx-auto bg-white rounded-full shadow-xl flex items-center justify-center mb-6")
            concat content_tag(:i, nil, class: "fas fa-image text-5xl text-medgemma-400")
            concat content_tag(:h3, "Modern Healthcare", class: "text-xl font-bold text-gray-800 mb-2")
            concat content_tag(:p, "Experience the future of healthcare with MedGemma Health", class: "text-gray-600")
          end
        end
        
        # Add animated decorative elements to all placeholders
        concat content_tag(:div, nil, class: "absolute top-5 left-5 w-3 h-3 rounded-full bg-medgemma-300 animate-pulse-slow")
        concat content_tag(:div, nil, class: "absolute bottom-8 right-8 w-2 h-2 rounded-full bg-purple-300 animate-pulse-slow-reverse")
        
        content
      end
    end
  end

  def milestone_icon(title)
    case title.downcase
    when /launch/
      'fa-rocket'
    when /patients/
      'fa-users'
    when /doctor|network/
      'fa-user-md'
    when /global|expansion/
      'fa-globe'
    when /ai|enhancement/
      'fa-brain'
    else
      'fa-star'
    end
  end

  def value_icon_class(value)
    case value.downcase
    when /privacy|security/
      { icon: 'fa-shield-alt', bg: 'bg-blue-100', text: 'text-blue-600', gradient: 'from-blue-500 to-blue-700' }
    when /care|quality/
      { icon: 'fa-heart-pulse', bg: 'bg-green-100', text: 'text-green-600', gradient: 'from-green-500 to-green-700' }
    when /access/
      { icon: 'fa-universal-access', bg: 'bg-purple-100', text: 'text-purple-600', gradient: 'from-purple-500 to-purple-700' }
    when /innovation/
      { icon: 'fa-lightbulb', bg: 'bg-amber-100', text: 'text-amber-600', gradient: 'from-amber-500 to-amber-700' }
    when /trust/
      { icon: 'fa-handshake', bg: 'bg-sky-100', text: 'text-sky-600', gradient: 'from-sky-500 to-sky-700' }
    when /improve/
      { icon: 'fa-arrow-trend-up', bg: 'bg-indigo-100', text: 'text-indigo-600', gradient: 'from-indigo-500 to-indigo-700' }
    else
      { icon: 'fa-star', bg: 'bg-gray-100', text: 'text-gray-600', gradient: 'from-gray-500 to-gray-700' }
    end
  end
  
  def team_photo(name, role = nil)
    # Define actual photo URLs for team members
    case name.downcase.gsub(/[^a-z]/, '')
    when /sarah|smith/
      photo_url = "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80"
    when /john|doe/
      photo_url = "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80"
    when /lisa|chen/
      photo_url = "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80"
    else
      # If no photo exists, create a gradient with initials
      initials = name.split(' ').map(&:first).join('')
      return content_tag :div, class: "w-full h-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center" do
        content_tag :span, initials, class: "text-white text-2xl font-bold"
      end
    end
    
    # If photo exists, return an image tag
    image_tag photo_url, alt: "#{name} - #{role}", class: "w-full h-full object-cover"
  end
  
  def feature_category_style(category, index = 0)
    styles = {
      "AI-Powered Diagnostics" => {
        icon: "fa-brain",
        color_class: "blue",
        gradient_from: "from-blue-500",
        gradient_to: "to-indigo-600",
        light_from: "from-blue-50",
        light_to: "to-indigo-100",
        image: "https://images.unsplash.com/photo-1581093196277-9d2e0b7a2d94?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
        pattern: "bg-[radial-gradient(ellipse_at_bottom_right,_var(--tw-gradient-stops))]",
        angle: "rotate-3",
        shape: "rounded-tr-3xl rounded-bl-3xl"
      },
      "Virtual Consultations" => {
        icon: "fa-video",
        color_class: "green",
        gradient_from: "from-green-500",
        gradient_to: "to-teal-600",
        light_from: "from-green-50",
        light_to: "to-teal-100",
        image: "https://images.unsplash.com/photo-1516841273335-e39b37888115?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
        pattern: "bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))]",
        angle: "-rotate-2",
        shape: "rounded-tl-3xl rounded-br-3xl"
      },
      "Patient Care" => {
        icon: "fa-heart",
        color_class: "rose",
        gradient_from: "from-rose-500",
        gradient_to: "to-pink-600",
        light_from: "from-rose-50",
        light_to: "to-pink-100",
        image: "https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
        pattern: "bg-[linear-gradient(to_right_bottom,_var(--tw-gradient-stops))]",
        angle: "rotate-1",
        shape: "rounded-tr-3xl rounded-bl-3xl"
      },
      "Emergency Services" => {
        icon: "fa-ambulance",
        color_class: "amber",
        gradient_from: "from-amber-500",
        gradient_to: "to-orange-600",
        light_from: "from-amber-50",
        light_to: "to-orange-100",
        image: "https://images.unsplash.com/photo-1612776569-b0d3c568ea2a?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
        pattern: "bg-[conic-gradient(at_top,_var(--tw-gradient-stops))]",
        angle: "-rotate-1",
        shape: "rounded-tl-3xl rounded-br-3xl"
      }
    }
    
    # Default style if category isn't found
    default_style = {
      icon: "fa-star",
      color_class: "purple",
      gradient_from: "from-purple-500",
      gradient_to: "to-violet-600",
      light_from: "from-purple-50",
      light_to: "to-violet-100",
      image: "https://images.unsplash.com/photo-1584367369853-8b966cf223f4?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80",
      pattern: "bg-gradient-to-br",
      angle: "rotate-0",
      shape: "rounded-2xl"
    }
    
    styles[category] || default_style
  end
  
  def feature_icon_style(feature_title)
    styles = {
      # AI-Powered Diagnostics Features
      "Symptom Analysis" => { 
        icon: "fa-stethoscope", 
        color: "text-blue-600", 
        bg: "bg-blue-100",
        gradient: "bg-gradient-to-br from-blue-500 to-indigo-600",
        hover: "group-hover:shadow-blue-300/30"
      },
      "Image Recognition" => { 
        icon: "fa-image", 
        color: "text-blue-600", 
        bg: "bg-blue-100",
        gradient: "bg-gradient-to-br from-blue-600 to-indigo-500",
        hover: "group-hover:shadow-blue-300/30" 
      },
      "Real-time Learning" => { 
        icon: "fa-chart-line", 
        color: "text-blue-600", 
        bg: "bg-blue-100",
        gradient: "bg-gradient-to-br from-indigo-600 to-blue-500",
        hover: "group-hover:shadow-blue-300/30"
      },
      
      # Virtual Consultation Features
      "24/7 Availability" => { 
        icon: "fa-clock", 
        color: "text-green-600", 
        bg: "bg-green-100",
        gradient: "bg-gradient-to-br from-green-500 to-teal-600",
        hover: "group-hover:shadow-green-300/30"
      },
      "Secure Video Calls" => { 
        icon: "fa-shield-alt", 
        color: "text-green-600", 
        bg: "bg-green-100",
        gradient: "bg-gradient-to-br from-teal-600 to-green-500",
        hover: "group-hover:shadow-green-300/30"
      },
      "Multi-specialty Access" => { 
        icon: "fa-user-md", 
        color: "text-green-600", 
        bg: "bg-green-100",
        gradient: "bg-gradient-to-br from-green-600 to-teal-500",
        hover: "group-hover:shadow-green-300/30"
      },
      
      # Patient Care Features
      "Digital Health Records" => { 
        icon: "fa-folder-open", 
        color: "text-rose-600", 
        bg: "bg-rose-100",
        gradient: "bg-gradient-to-br from-rose-500 to-pink-600",
        hover: "group-hover:shadow-rose-300/30"
      },
      "Medication Tracking" => { 
        icon: "fa-pills", 
        color: "text-rose-600", 
        bg: "bg-rose-100",
        gradient: "bg-gradient-to-br from-pink-600 to-rose-500",
        hover: "group-hover:shadow-rose-300/30"
      },
      "Treatment Plans" => { 
        icon: "fa-clipboard-check", 
        color: "text-rose-600", 
        bg: "bg-rose-100",
        gradient: "bg-gradient-to-br from-rose-600 to-pink-500",
        hover: "group-hover:shadow-rose-300/30"
      },
      
      # Emergency Services Features
      "Urgent Care Triage" => { 
        icon: "fa-first-aid", 
        color: "text-amber-600", 
        bg: "bg-amber-100",
        gradient: "bg-gradient-to-br from-amber-500 to-orange-600",
        hover: "group-hover:shadow-amber-300/30"
      },
      "Emergency Contacts" => { 
        icon: "fa-phone-alt", 
        color: "text-amber-600", 
        bg: "bg-amber-100",
        gradient: "bg-gradient-to-br from-orange-600 to-amber-500",
        hover: "group-hover:shadow-amber-300/30"
      },
      "Location Services" => { 
        icon: "fa-map-marker-alt", 
        color: "text-amber-600", 
        bg: "bg-amber-100",
        gradient: "bg-gradient-to-br from-amber-600 to-orange-500",
        hover: "group-hover:shadow-amber-300/30"
      }
    }
    
    # Default style if feature isn't found
    default_style = { 
      icon: "fa-check", 
      color: "text-purple-600", 
      bg: "bg-purple-100",
      gradient: "bg-gradient-to-br from-purple-500 to-violet-600",
      hover: "group-hover:shadow-purple-300/30"
    }
    
    styles[feature_title] || default_style
  end
  
  def feature_illustration(category_name)
    # Return high-quality feature imagery based on category name
    case category_name
    when "AI-Powered Diagnostics"
      image_url = "https://images.unsplash.com/photo-1581093196277-9d2e0b7a2d94?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80"
      alt_text = "AI analyzing medical scan"
      highlight = "Neural network diagnostics"
    when "Virtual Consultations"
      image_url = "https://images.unsplash.com/photo-1516841273335-e39b37888115?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80"
      alt_text = "Doctor on video consultation"
      highlight = "HD secure video"
    when "Patient Care"
      image_url = "https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80"
      alt_text = "Patient care dashboard"
      highlight = "Smart health tracking"
    when "Emergency Services"
      image_url = "https://images.unsplash.com/photo-1612776569-b0d3c568ea2a?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80"
      alt_text = "Emergency response services"
      highlight = "Rapid response protocol"
    else
      image_url = "https://images.unsplash.com/photo-1584367369853-8b966cf223f4?ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=80"
      alt_text = "Healthcare innovation"
      highlight = "Advanced technology"
    end
    
    return { 
      url: image_url, 
      alt: alt_text, 
      highlight: highlight,
      bg_accent: category_bg_accent(category_name)
    }
  end

  def category_bg_accent(category_name)
    case category_name
    when "AI-Powered Diagnostics"
      {
        pattern: "polygon(74% 61%, 97% 11%, 100% 90%, 19% 100%, 0% 63%, 37% 27%)",
        color1: "rgba(59, 130, 246, 0.3)",
        color2: "rgba(79, 70, 229, 0.2)"
      }
    when "Virtual Consultations"
      {
        pattern: "polygon(50% 0%, 100% 25%, 100% 75%, 50% 100%, 0% 75%, 0% 25%)",
        color1: "rgba(16, 185, 129, 0.3)",
        color2: "rgba(5, 150, 105, 0.2)"
      }
    when "Patient Care"
      {
        pattern: "polygon(25% 0%, 75% 0%, 100% 50%, 75% 100%, 25% 100%, 0% 50%)",
        color1: "rgba(244, 63, 94, 0.3)",
        color2: "rgba(219, 39, 119, 0.2)"
      }
    when "Emergency Services"
      {
        pattern: "polygon(20% 0%, 80% 0%, 100% 20%, 100% 80%, 80% 100%, 20% 100%, 0% 80%, 0% 20%)",
        color1: "rgba(245, 158, 11, 0.3)",
        color2: "rgba(234, 88, 12, 0.2)"
      }
    else
      {
        pattern: "circle(50% at 50% 50%)",
        color1: "rgba(139, 92, 246, 0.3)",
        color2: "rgba(124, 58, 237, 0.2)"
      }
    end
  end

  def feature_highlight_stats(category_name)
    case category_name
    when "AI-Powered Diagnostics"
      {
        stat: "95%",
        text: "diagnostic accuracy",
        icon: "fa-chart-line"
      }
    when "Virtual Consultations"
      {
        stat: "24/7",
        text: "care availability",
        icon: "fa-clock"
      }
    when "Patient Care"
      {
        stat: "100%",
        text: "HIPAA compliant",
        icon: "fa-shield-check"
      }
    when "Emergency Services"
      {
        stat: "< 3min",
        text: "response time",
        icon: "fa-bolt"
      }
    else
      {
        stat: "Top",
        text: "rated technology",
        icon: "fa-star"
      }
    end
  end
  
  def contact_method_style(method_type)
    case method_type
    when "email"
      {
        icon: "fa-envelope",
        gradient_from: "from-blue-500",
        gradient_to: "to-indigo-600",
        light_bg: "bg-blue-50",
        text_color: "text-blue-600",
        hover_shadow: "group-hover:shadow-blue-500/20",
        shape: "rounded-tr-xl rounded-bl-xl",
        animation: "animate-float-slow",
        pattern: "bg-[radial-gradient(ellipse_at_bottom_right,_var(--tw-gradient-stops))]"
      }
    when "phone"
      {
        icon: "fa-phone-alt",
        gradient_from: "from-green-500",
        gradient_to: "to-emerald-600",
        light_bg: "bg-green-50",
        text_color: "text-green-600",
        hover_shadow: "group-hover:shadow-green-500/20",
        shape: "rounded-tl-xl rounded-br-xl",
        animation: "animate-float-slow-reverse",
        pattern: "bg-[radial-gradient(ellipse_at_top_left,_var(--tw-gradient-stops))]"
      }
    when "chat"
      {
        icon: "fa-comments",
        gradient_from: "from-purple-500",
        gradient_to: "to-violet-600",
        light_bg: "bg-purple-50",
        text_color: "text-purple-600",
        hover_shadow: "group-hover:shadow-purple-500/20",
        shape: "rounded-tr-xl rounded-bl-xl",
        animation: "animate-float-slow",
        pattern: "bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))]"
      }
    when "address"
      {
        icon: "fa-map-marker-alt",
        gradient_from: "from-amber-500",
        gradient_to: "to-orange-600",
        light_bg: "bg-amber-50",
        text_color: "text-amber-600",
        hover_shadow: "group-hover:shadow-amber-500/20",
        shape: "rounded-tl-xl rounded-br-xl",
        animation: "animate-float-slow-reverse",
        pattern: "bg-[conic-gradient(at_top_right,_var(--tw-gradient-stops))]"
      }
    else
      {
        icon: "fa-circle-question",
        gradient_from: "from-gray-500",
        gradient_to: "to-gray-600",
        light_bg: "bg-gray-50",
        text_color: "text-gray-600",
        hover_shadow: "group-hover:shadow-gray-500/20",
        shape: "rounded-2xl",
        animation: "animate-float-slow",
        pattern: "bg-gradient-to-br"
      }
    end
  end

  def contact_form_input_style(field_type)
    base_styles = "w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
    
    case field_type
    when "text", "name"
      "#{base_styles} border-gray-300"
    when "email" 
      "#{base_styles} border-gray-300"
    when "phone"
      "#{base_styles} border-gray-300"
    when "select"
      "#{base_styles} border-gray-300 bg-white"
    when "textarea"
      "#{base_styles} border-gray-300 resize-none"
    when "checkbox"
      "w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-2 focus:ring-blue-500"
    when "submit"
      "w-full px-8 py-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg font-medium hover:shadow-lg transform hover:-translate-y-0.5 transition-all"
    else
      "#{base_styles} border-gray-300"
    end
  end
  
  def office_location_style(location)
    case location.downcase
    when /san francisco/, /sf/, /california/
      {
        icon: "fa-sun",
        image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        color: "blue",
        accent: "bg-gradient-to-br from-blue-500 to-cyan-600"
      }
    when /new york/, /ny/
      {
        icon: "fa-building",
        image: "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        color: "purple",
        accent: "bg-gradient-to-br from-purple-500 to-indigo-600"
      }
    when /london/
      {
        icon: "fa-cloud-rain",
        image: "https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        color: "indigo",
        accent: "bg-gradient-to-br from-indigo-500 to-blue-600"
      }
    when /tokyo/
      {
        icon: "fa-torii-gate",
        image: "https://images.unsplash.com/photo-1503899036084-c55cdd92da26?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        color: "rose",
        accent: "bg-gradient-to-br from-rose-500 to-pink-600"
      }
    else
      {
        icon: "fa-map-marker-alt",
        image: "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80",
        color: "green",
        accent: "bg-gradient-to-br from-green-500 to-emerald-600"
      }
    end
  end
  
  def social_icon_style(platform)
    case platform.to_s.downcase
    when "twitter", "x"
      { 
        icon: "fa-brands fa-x-twitter", 
        bg: "bg-black hover:bg-gray-800", 
        text: "text-white",
        hover: "hover:shadow-gray-500/30"
      }
    when "facebook"
      { 
        icon: "fa-brands fa-facebook-f", 
        bg: "bg-blue-600 hover:bg-blue-700", 
        text: "text-white",
        hover: "hover:shadow-blue-500/30"
      }
    when "instagram"
      { 
        icon: "fa-brands fa-instagram", 
        bg: "bg-gradient-to-br from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700", 
        text: "text-white",
        hover: "hover:shadow-pink-500/30"
      }
    when "linkedin"
      { 
        icon: "fa-brands fa-linkedin-in", 
        bg: "bg-blue-700 hover:bg-blue-800", 
        text: "text-white", 
        hover: "hover:shadow-blue-600/30"
      }
    when "youtube"
      { 
        icon: "fa-brands fa-youtube", 
        bg: "bg-red-600 hover:bg-red-700", 
        text: "text-white",
        hover: "hover:shadow-red-500/30"
      }
    else
      { 
        icon: "fa-globe", 
        bg: "bg-gray-600 hover:bg-gray-700", 
        text: "text-white",
        hover: "hover:shadow-gray-500/30"
      }
    end
  end

  private

  def asset_exists?(path)
    if Rails.configuration.assets.compile
      Rails.application.precompiled_assets.include?(path)
    else
      Rails.application.assets_manifest.assets[path].present?
    end
  rescue
    false
  end
end
