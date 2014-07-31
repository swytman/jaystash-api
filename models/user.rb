class User < ActiveRecord::Base
  require 'digest/sha2'

  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password_hash, presence: true

  def self.create_and_check email, password
    email = email.downcase
    return :email_exists if User.find_by(email: email).present?
    return :bad_email unless VALID_EMAIL_REGEX.match(email)
    user = User.new(email: email)
    user.gen_password password
    user.gen_token
    if user.save
      return user
    else
      return :error
    end
  end

  def self.login email, password
    email = email.downcase
    user = User.find_by(email: email)
    return :not_found unless user
    return :not_found unless user.check_password password
    user
  end


  def gen_password password
    self.salt = Digest::SHA2.hexdigest(Time.now.to_s)
    self.password_hash = Digest::SHA2.hexdigest(self.salt + password)
  end

  def gen_token
    self.token = Digest::SHA2.hexdigest(self.salt + Time.now.to_s)
  end

  def check_password password
    Digest::SHA2.hexdigest(self.salt + password) == self.password_hash
  end

  def check_token token
    self.token == token
  end


end