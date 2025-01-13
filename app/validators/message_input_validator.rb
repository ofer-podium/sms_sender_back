# app/validators/message_input_validator.rb
class MessageInputValidator
  include ActiveModel::Model

  attr_accessor :recipient_phone, :content

  validates :recipient_phone, presence: true, format: { with: /\A\+\d{1,15}\z/, message: "must be a valid phone number with country code" }
  validates :content, presence: true, length: { maximum: 250 }

  def self.validate(params)
    validator = new(params)
    if validator.valid?
      { success: true }
    else
      { success: false, errors: validator.errors.full_messages }
    end
  end
end