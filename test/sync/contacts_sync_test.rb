require 'test_helper'

class ContactSyncTest < ActiveSupport::TestCase
  def setup
    @current_user = User.create! name: 'John Doe', phone: '+0000001'
    @contact_one = {contact_id: '4cdab6c0-fda7-4979-a668-29186c0dbe0e',
                    name: 'Tom Cruise', phones: '+0000002'}
    @user_one = User.new name: 'Tomas Cruise', phone: '+0000002'
    @contact_two = {contact_id: 'e6e53cd4-1c06-4f53-b65c-bce49ec1cb2a',
                    name: 'Leonardo DiCaprio', phones: '+0000003'}
  end

  test 'create new contact' do
    sync_back = ContactsSync.sync([@contact_one], @current_user)
    assert_empty sync_back
    assert_equal Contact.all.size, 1
    assert_contact Contact.first, @contact_one
  end

  test 'update contact name' do
    ContactsSync.sync([@contact_one], @current_user)
    new_name = 'Dwayne Johnson'
    sync_back = ContactsSync.sync([@contact_one.merge(name: new_name)], @current_user)
    assert_empty sync_back
    assert_equal Contact.all.size, 1
    assert_equal Contact.first.name, new_name
  end

  test 'update contact phone' do
    ContactsSync.sync([@contact_one], @current_user)
    new_phones = @contact_one[:phones] + ',+0000010'
    sync_back = ContactsSync.sync([@contact_one.merge(phones: new_phones)], @current_user)
    assert_empty sync_back
    assert_equal Contact.all.size, 1
    assert_equal Contact.first.phones.split(',').size, 2
  end

  test 'update contact with existing user phone' do
    ContactsSync.sync([@contact_two], @current_user)
    @user_one.save!
    new_phones = @contact_one[:phones] + ',' + @user_one.phone
    sync_back = ContactsSync.sync([@contact_one.merge(phones: new_phones)], @current_user)
    assert_not_empty sync_back
    assert_equal Contact.all.size, 1
    assert_user @user_one, sync_back.first
  end

  test 'create contact with existed user' do
    @user_one.save!
    sync_back = ContactsSync.sync([@contact_one], @current_user)
    assert_not_empty sync_back
    assert Contact.all.empty?
    assert_user @user_one, sync_back.first
  end

  test 'update existed mapped contact' do
    #ToDo: implement
  end

  private

  def assert_contact(contact, hash)
    assert_equal contact.name, hash[:name]
    assert_equal contact.internal_id, hash[:contact_id]
    assert_equal contact.phones, hash[:phones]
    assert_not_nil contact.friend
  end

  def assert_user(user, hash)
    assert hash[:app_installed]
    assert_equal user.id, hash[:contact_id]
    assert_equal user.name, hash[:name]
  end
end
