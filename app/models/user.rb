class User < ActiveRecord::Base

  devise :database_authenticatable, :confirmable, :lockable,
         :rememberable, :trackable, :validatable, :registerable, :recoverable,
         :encryptable, :encryptor => :sha512



  attr_accessible :login, :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :patronymic, :phone, :address, :birthday, :user_type_id

  attr_accessible :gender, :kind, :time_zone, :locale

  attr_accessible :user_role_id, :trust_state, :as => :admin

  #attr_accessible :user_role_id, :trust_state

  enumerated_attribute :gender_type, :id_attribute => :gender, :class => ::GenderType
  enumerated_attribute :user_role_type, :id_attribute => :user_role_id, :class => ::UserRoleType
  enumerated_attribute :trust_state_type, :id_attribute => :trust_state, :class => ::UserState
  enumerated_attribute :user_type, :id_attribute => :user_type_id, :class => ::UserType

  has_one :avatar, :as => :assetable, :dependent => :destroy, :autosave => true
  #has_many :accounts, :dependent => :destroy




  before_validation :generate_login

  fileuploads :avatar

  include Utils::Models::Base
  include Utils::Models::AdminAdds


  has_many :reviews


  def activate
    self.trust_state = ::UserState.active.id
    self.locked_at = nil
  end


  def title
    full_name.strip.presence || email
  end

  def display_email
    email.presence || unconfirmed_email
  end

  def check_confirmation
    if trust_state == ::UserState.pending.id
      skip_confirmation!
    end
  end

  def sex=(val)
    if val.to_i.zero?
      self.gender = ::GenderType.female.id
    else
      self.gender = ::GenderType.male.id
    end
  end

  def password_required?
    return false if accounts.any?
    return true if password.present?
    return false if pending?
    return true if new_record? && !pending?
    return false if persisted? && password.blank?
    super
    #(persisted? && !password.blank?) && super
  end

  def email_required?
    !pending? || email.present?
  end

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  def suspend!
    self.update_attribute(:trust_state, ::UserState.suspended.id)
  end

  def delete!
    self.update_attribute(:trust_state, ::UserState.deleted.id)
  end

  def unsuspend!
    self.update_attribute(:trust_state, ::UserState.active.id)
  end

  def deleted?
    trust_state == ::UserS

  def default?
    has_role?(:default)
  end

  def moderator?
    has_role?(:moderator)
  end

  def admin?
    has_role?(:admin)
  end

  def has_role?(role_name)
    user_role_type.try(:code) == role_name
  end

  def user_role_id=(value)
    value = value.to_i
    if ::UserRoleType.legal?(value)
      self.user_role_type = ::UserRoleType.find(value)
    end
  end

  def state
    return 'active' if active_for_authentication?
    return 'register' unless confirmed?
    return 'suspend' if access_locked?
    return 'delete' if deleted?
    'pending'
  end


  def trusted?
    self.trust_state == ::UserState.active.id
  end

  # for devise
  def active_for_authentication?
    super && trusted?
  end

  def inactive_message
    trusted? ? super : :not_trusted_user
  end

  def pending?
    trust_state == ::UserState.pending.id
  end




  protected

  #def set_default_role
  #  self.role_type = RoleType.default
  #end

  def generate_login
    self.login ||= begin
      unless email.blank?
        tmp_login = email.split('@').first
        tmp_login.parameterize.downcase.gsub(/[^A-Za-z0-9-]+/, '-').gsub(/-+/, '-')
      end
    end
  end

end
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  login                  :string(20)
#  user_role_id           :integer          default(1)
#  trust_state            :integer          default(1)
#  first_name             :string(255)
#  last_name              :string(255)
#  patronymic             :string(255)
#  phone                  :string(255)
#  address                :string(255)
#  birthday               :datetime
#  account_id             :integer
#  email                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  password_salt          :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  photo                  :string(255)
#
# Indexes
#
#  index_users_on_confirmation_token                       (confirmation_token) UNIQUE
#  index_users_on_email_and_account_id                     (email,account_id)
#  index_users_on_last_name_and_first_name_and_patronymic  (last_name,first_name,patronymic)
#  index_users_on_login                                    (login)
#  index_users_on_reset_password_token                     (reset_password_token) UNIQUE
#

