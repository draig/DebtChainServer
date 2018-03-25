class Payment < ApplicationRecord

  belongs_to :creator, class_name: 'User'
  belongs_to :debt, class_name: 'User'

  def can_edit?(user)
    creator.id == user.id
  end
end
