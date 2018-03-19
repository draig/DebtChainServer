class DebtSync

  def self.sync(debts, user)
    sync_back = []
    debts.each do |debt|
      sync_back << sync_debt(debt, user)
    end
    sync_back.reject &:nil?
  end

  def self.sync_with_new_user(contacts, user)
    contacts.each do |contact|
      relevance = Debt.where('party LIKE ?', "%#{contacts.internal_id}%")
      relevance.reject(&:party.split(',').find(contact.internal_id).nil?).each do |debt|
        update_user_in_debt debt, contact, user
      end
    end
  end

  private

  def self.update_user_in_debt(debt, contact, user)
    new_party = (debt.party.split(',') - [contact.internal_id] + user.id).join ','
    debt.update! party: new_party
    update_debt_subscribes debt
    Subscribe.create! user_id: user.id, debt_id: debt.id
  end

  def self.update_debt_subscribes(debt)
    Subscribe.find_by(debt_id: debt.id, active: true).update(sync: false)
  end

  def self.sync_debt(debt, user)
    if debt[:id] =~ /^local/
      create_debt debt, user
    else
      update_debt debt, user
    end
  end

  def self.create_debt(debt, user)
    Debt.create! title: debt[:title], party: debt[:party], currency:
        debt[:currency], creator_id: user.id
  end

  def self.update_debt(debt, user)
    existed_debt = Debt.find debt[:id]
    if permission? existed_debt.party, user
      sync_party existed_debt, debt
      existed_debt.update! title: debt[:title], currency: debt[:currency]
      #ToDo: update only for other users
    end
  end

  def self.permission?(party, user)
    party.find_index(user.id).nil?
  end

  def self.sync_party(existed_debt, debt)
    new_party = debt.party.split(',') - existed_debt.party.split(',')
    add_new_party new_party, existed_debt unless new_party.empty?
  end

  def add_new_party(new_party, debt)
    new_party_users = new_party.reject do |id|
      id =~ /^local/
    end
    new_party_users.each do |party_user|
      Subscribe.create! debt_id: debt.id, user_id: party_user.id, sync: false
    end
    debt.party << ',' << new_party.join(',')
  end
end
