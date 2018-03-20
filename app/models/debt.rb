
class Debt < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :subscribes
  has_many :users, through: :subscribes

  after_create do |debt|
    debt.split_party.each do |user_id|
      Subscribe.create! debt_id: id, user_id: user_id, sync: user_id == creator_id unless user_id =~ /^local/
    end
  end

  def update_user_in_party(contact_id, user_id)
    new_party = (split_party - [contact_id] + user_id).join ','
    update! party: new_party
    update_subscribes
    Subscribe.create! user_id: user_id, debt_id: id
  end

  def update_with_subscribes!(hash, user)
    update! title: hash[:title], currency: hash[:currency]
    update_subscribes user.id
  end

  def update_party(new_party)
    difference = split_party - new_party.split(',')
    add_party difference unless difference.empty?
  end

  def split_party
    party.split(',')
  end

  def can_edit?(user)
    split_party.find_index(user.id).present?
  end

  private

  def add_party(new_party)
    new_party_users = new_party.reject do |id|
      id =~ /^local/
    end
    create_subscribes new_party_users
    party << ',' << new_party.join(',')
  end

  def update_subscribes(user_id = nil)
    Subscribe.where(debt_id: id, active: true).where.not(user_id: user_id).update(sync: false)
  end

  def create_subscribes(user_ids)
    user_ids.each do |user_id|
      Subscribe.create! debt_id: id, user_id: user_id, sync: false
    end
  end
end
