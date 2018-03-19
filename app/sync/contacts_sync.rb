class ContactsSync

  def self.sync(contacts, friend)
    sync_back = []
    contacts.each do |contact|
      sync_back << sync_contact(contact, friend)
    end
    sync_back.reject &:nil?
  end

  def self.sync_with_new_user(user)
    relevance = Contact.where('phones LIKE ?', "%#{Regexp.quote user.phone}%")
    relevance.reject(&:phones.split(',').find(user.phone).nil?).each do |contact|
      contact.update! mapped_id: user.id, sync: false
    end
  end

  private

  def self.sync_contact(contact, friend)
    existed_contact = Contact.find_by friend_id: friend.id, internal_id: contact[:contact_id]
    if existed_contact.present?
      sync_existed_contact(contact, existed_contact)
    else
      sync_new_contact(contact, friend)
    end
  end

  def self.to_user(contact, user)
    contact.merge(app_installed: true, contact_id: user.id, name: user.name)
  end

  def self.sync_existed_contact(contact, existed_contact)
    to_user contact, existed_contact if existed_contact.mapped.present?

    phones_difference = contact[:phones].split(',') - existed_contact.phones.split(',')
    if !phones_difference.length
      existed_contact.update! name: contact[:name]
      nil
    else
      sync_new_phones contact, existed_contact, phones_difference
    end
  end

  def self.sync_new_phones(contact, existed_contact, new_phones)
    user = User.find_by_phones new_phones
    if user.present?
      existed_contact.update! mapped_id: user.id
      to_user contact, user
    else
      existed_contact.update! phones: contact[:phones], name: contact[:name]
      nil
    end
  end

  def self.sync_new_contact(contact, friend)
    user = User.find_by_phones contact[:phones].split(',')
    if user.present?
      to_user contact, user
    else
      Contact.create! friend_id: friend.id, phones: contact[:phones],
                      name: contact[:name], internal_id: contact[:contact_id]
      nil
    end
  end
end