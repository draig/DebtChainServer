
class Debt < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :subscribes
  has_many :users, through: :subscribes

  after_create do |debt|
    Subscribe.create! debt_id: debt.id, user_id: debt.creator_id
  end

  after_update do |debt|
    Subscribe.find_by(debt_id: debt.id, active: true).update! sync: false
  end
end
