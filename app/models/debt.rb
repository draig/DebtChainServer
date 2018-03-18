
class Debt < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :subscribes
  has_many :users, through: :subscribes
end
