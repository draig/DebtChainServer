class User < ApplicationRecord

  def self.auth(token)
    User.find(JsonWebToken.decode(token)[:user_id])
  end

  def dto
    { id: id, name: name, phone: phone }
  end

  def self.find_by_phones(phones)
    phones.each { |phone|
      user = User.find_by phone: phone
      return user if user.present?
    }
    nil
  end
end
