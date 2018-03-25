class PaymentSync

  def self.sync(payments, user)
    sync_back = []
    payments.each do |payments_hash|
      sync_back << sync_payments(payments_hash, user)
    end
    sync_back.reject &:nil?
  end

=begin
  def self.sync_with_new_user(contacts, user)
    contacts.each do |contact|
      relevance = Debt.where('party LIKE ?', "%#{contacts.internal_id}%")
      relevance.reject(&:party.split(',').find(contact.internal_id).nil?).each do |debt|
        #update_user_in_debt debt, contact, user
        debt.update_user_in_party contact.internal_id, user.id
      end
    end
  end
=end

  private

  def self.sync_payments(payments_hash, user)
    if payments_hash[:id] =~ /^local/
      create_payment payments_hash, user
    else
      update_payment payments_hash, user
    end
  end

  def self.create_payment(hash, user)
    Payment.create! title: hash[:title], party: hash[:party], currency:
        hash[:currency], creator_id: user.id
  end

  def self.update_payment(hash, user)
    existed_payment = Payment.find hash[:id]
    existed_payment.update hash if existed_payment.can_edit? user
    nil
  end
end
