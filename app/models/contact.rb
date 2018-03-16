class Contact < ApplicationRecord
  belongs_to :friend, class_name: 'User', optional: true
  belongs_to :mapped, class_name: 'User', optional: true
end
