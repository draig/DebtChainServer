class DebtSync

  def self.sync(debts, user)
    sync_back = []
    debts.each do |debt_hash|
      sync_back << sync_debt(debt_hash, user)
    end
    sync_back.reject &:nil?
  end

  def self.sync_with_new_user(contacts, user)
    contacts.each do |contact|
      relevance = Debt.where('party LIKE ?', "%#{contacts.internal_id}%")
      relevance.reject(&:party.split(',').find(contact.internal_id).nil?).each do |debt|
        #update_user_in_debt debt, contact, user
        debt.update_user_in_party contact.internal_id, user.id
      end
    end
  end

  def self.update_debt_hash(debts_hash, contacts_syncback)
    debts_hash.each do |debt_hash|
      debt_hash[:party].re
      #'jasd-asdasd-asd-asd-asdas,local-sdasd-as-dasd-asd-asd-asda,local-sadas-sad-asd-as-sda'.gsub(/(^|,)jasd-asdasd-asd-asd-asdas(,|$)/, '12345')
    end
  end

  private

  def self.sync_debt(debt_hash, user)
    if debt_hash[:id] =~ /^local/
      create_debt debt_hash, user
    else
      update_debt debt_hash, user
    end
  end

  def self.create_debt(debt_hash, user)
    Debt.create! title: debt_hash[:title], party: debt_hash[:party], currency:
        debt_hash[:currency], creator_id: user.id
  end

  def self.update_debt(debt_hash, user)
    existed_debt = Debt.find debt_hash[:id]
    if existed_debt.can_edit? user
      existed_debt.update_party debt_hash[:party]
      existed_debt.update_with_subscribes! debt_hash, user
    end
    nil
  end
end
