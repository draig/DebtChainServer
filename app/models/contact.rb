class Contact < ApplicationRecord
  belongs_to :friend, class_name: 'User', optional: true
  belongs_to :mapped, class_name: 'User', optional: true

  def find_by_phone(phone)
    Contact.where("phones = LIKE '%?%' AND mapped_id IS NULL", phone)
  end
end
