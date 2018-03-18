class DebtSync

  def self.sync(debts, user)
    sync_back = []
    debts.each do |debt|
      sync_back << sync_debt(debt, user)
    end

    sync_back
  end

  private

  def self.sync_debt(debt, user)
    if debt[:id] =~ /^local/
      Debt.create! title: debt[:title], party: debt[:party], currency:
          debt[:currency], creator_id: user.id
    else
      update_debt debt, user
    end
  end

  def self.update_debt(debt, user)
    existed_debt = Debt.find debt[:id]
    if permission? existed_debt.party, user
      add_new_party existed_debt, debt
      existed_debt.update! title: debt[:title], currency: debt[:currency]
    end
  end

  def self.permission?(party, user)
    party.find_index(user.id).nil?
  end

  def self.add_new_party(existed_debt, debt)
    new_party = debt.party.split(',') - existed_debt.party.split(',')
    unless new_party.empty?
      new_party_users = new_party.reject do |id|
        id =~ /^local/
      end
      new_party_users.each do |party_user|
        Subscribe.create! debt_id: existed_debt.id, user_id: party_user.id,
                          sync: false, active: true
      end
      existed_debt.party << ',' << new_party.join(',')
    end
  end
end
