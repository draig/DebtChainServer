class User < ApplicationRecord
  has_many :subscribes
  has_many :debts, through: :subscribes

  before_create do |user|
    user.ava = DefaultAvatart.all.sample.url
  end

  def self.auth(token)
    User.find(JsonWebToken.decode(token)[:user_id])
  end

  def dto
    { id: id, name: name, phone: phone, ava: ava }
  end

  def self.find_by_phones(phones)
    phones.each do |phone|
      user = User.find_by phone: phone
      return user if user.present?
    end
    nil
  end
end
