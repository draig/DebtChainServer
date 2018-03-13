class Contact < ApplicationRecord
  belongs_to :friend, class_name: 'User'
  belongs_to :mapped, class_name: 'User'
end
