class User < ApplicationRecord
    before_create :generate_channel
  
    private
  
    def generate_channel
      self.channel = SecureRandom.hex(10)
    end
  end