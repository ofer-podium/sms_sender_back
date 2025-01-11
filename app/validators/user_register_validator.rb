# app/validators/user_register_validator.rb
class UserRegisterValidator
    include ActiveModel::Model
  
    attr_accessor :username, :password, :email
  
    validates :username, presence: true, length: { maximum: 50 }
    validates :password, presence: true, length: { minimum: 8 }
  
    def self.validate(params)
      validator = new(params)
      if validator.valid?
        { success: true }
      else
        { success: false, errors: validator.errors.full_messages }
      end
    end
  end