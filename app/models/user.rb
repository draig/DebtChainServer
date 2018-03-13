class User < ApplicationRecord
  def self.auth(token)
    User.find(JsonWebToken.decode(token)[:user_id])
  end

  def dto
    { id: id, name: name, phone: phone }
  end
end
