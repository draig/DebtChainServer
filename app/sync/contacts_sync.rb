class ContactsSync
  def self.sync(contacts, friend)
    contacts.each { |contact|
      existed_contact = Contact.find_by friend_id: friend.id, internal_id: contact[:contact_id]
      if existed_contact.present?
        sync_existed_contact contact, existed_contact
      else
        sync_new_contact contact, friend
      end
    }
  end

  private

  def self.to_user(contact, user)
    contact[:app_installed] = true
    contact[:contact_id] = user.id
    contact[:name] = user.name
  end

  def self.sync_existed_contact(contact, existed_contact)
    phones_difference = contact[:phones].split(',') - existed_contact[:phones].split(',')
    if !phones_difference.length
      existed_contact.update! name: contact[:name]
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
    end
  end

  def self.sync_new_contact(contact, friend)
    user = User.find_by_phones contact[:phones].split(',')
    if user.present?
      puts contact
      to_user contact, user
    else
      Contact.create! friend_id: friend.id, phones: contact[:phones], name: contact[:name], internal_id: contact[:contact_id]
    end
  end
end