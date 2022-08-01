class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
                   length: {maximum: Settings.user.name_max_length}
  validates :email, presence: true,
                    length: {maximum: Settings.user.email_max_length},
                    format: {
                      with: Regexp.new(Settings.user.VALID_EMAIL_REGEX, true)
                    },
                    uniqueness: true
  validates :password, presence: true,
                       length: {minimum: Settings.user.password_min_length}

  has_secure_password

  private
  def downcase_email
    self.email = email.downcase
  end
end
