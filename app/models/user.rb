class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # User status enum
  enum :status, {
    pending: 0,
    active: 1,
    suspended: 2,
    inactive: 3
  }

  # HIPAA compliance status enum
  enum :hipaa_compliance_status, {
    not_required: 0,
    pending_verification: 1,
    compliant: 2,
    non_compliant: 3
  }

  # Role-based methods
  def admin?
    type == "AdminUser"
  end

  def doctor?
    type == "Doctor"
  end

  def patient?
    type == "Patient"
  end

  def nurse?
    type == "Nurse"
  end

  def staff?
    type == "StaffMember"
  end

  def role_name
    case type
    when "AdminUser" then "Administrator"
    when "Doctor" then "Doctor"
    when "Patient" then "Patient"
    when "Nurse" then "Nurse"
    when "StaffMember" then "Staff"
    else "User"
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # These are placeholder methods since the actual fields are encrypted
  # You would need to implement proper decryption logic
  def first_name
    "John" # Placeholder
  end

  def last_name
    "Doe" # Placeholder
  end
end
