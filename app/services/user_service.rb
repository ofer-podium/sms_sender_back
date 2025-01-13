require 'bcrypt'

class UserService
  def self.hash_password(password)
    BCrypt::Password.create(password)
  end

  # check password:
  def self.check_password(password, hashed_password)
    BCrypt::Password.new(hashed_password) == password
  end

  # Find a user by ID
  def self.find_user(user_id)
    user = User.find_by(id: user_id)
    if user
      { success: true, user: user }
    else
      { success: false, error: "User not found" }
    end
  end

  # Find a user by username
  def self.find_user_by_username(username)
    user = User.find_by(username: username)
    if user
      { success: true, user: user }
    else
      { success: false, error: "User not found" }
    end
  end

  def self.username_taken?(username)
    User.exists?(username: username)
  end

  def self.create_user(username:, password:)
    hashed_password = hash_password(password)

    user = User.new(username: username, hashed_password: hashed_password)
    if user.save
      { success: true, user: user }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end

end