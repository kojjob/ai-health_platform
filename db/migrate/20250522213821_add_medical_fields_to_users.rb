class AddMedicalFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    # User type and basic encrypted information
    add_column :users, :type, :string
    add_column :users, :first_name_ciphertext, :text
    add_column :users, :last_name_ciphertext, :text
    add_column :users, :phone_number_ciphertext, :text
    add_index :users, :type

    # Security and authentication
    add_column :users, :two_factor_enabled, :boolean, default: false
    add_column :users, :two_factor_secret_ciphertext, :text
    add_index :users, :two_factor_enabled

    # User status and activity tracking
    add_column :users, :status, :integer, default: 0
    add_column :users, :last_activity_at, :datetime
    add_index :users, :status
    add_index :users, :last_activity_at

    # Medical-specific information (encrypted)
    add_column :users, :date_of_birth_ciphertext, :text
    add_column :users, :blood_type_ciphertext, :text
    add_column :users, :allergies_ciphertext, :text
    add_column :users, :medical_conditions_ciphertext, :text
    add_column :users, :medications_ciphertext, :text
    add_column :users, :emergency_contact_ciphertext, :text

    # Healthcare provider specific fields
    add_column :users, :medical_license_number_ciphertext, :text
    add_column :users, :specialization, :string
    add_column :users, :years_of_experience, :integer
    add_column :users, :accepting_new_patients, :boolean, default: true
    add_index :users, :specialization
    add_index :users, :accepting_new_patients

    # Location and availability
    add_column :users, :timezone, :string
    add_column :users, :practice_location_ciphertext, :text
    add_column :users, :available_for_emergency, :boolean, default: false
    add_index :users, :timezone
    add_index :users, :available_for_emergency

    # Verification and compliance
    add_column :users, :identity_verified, :boolean, default: false
    add_column :users, :last_background_check_at, :datetime
    add_column :users, :hipaa_compliance_status, :integer, default: 0
    add_index :users, :identity_verified
    add_index :users, :hipaa_compliance_status
  end
end
