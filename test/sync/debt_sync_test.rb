require 'test_helper'

class DebtSyncTest < ActiveSupport::TestCase
  def setup
    @current_user = User.create! name: 'John Doe', phone: '+0000001'
    @user_one = User.create! name: 'Bala Paranj', phone: '+0000002'
    @debt_one = { id: 'local-001', title: 'Pizza', party: @current_user.id.dup,
                  currency: 'usd' }
  end

  test 'create new debt' do
    sync_back = DebtSync.sync([@debt_one], @current_user)
    assert_not_empty sync_back
    assert_equal Debt.all.size, 1
    assert_equal Subscribe.all.size, 1
    assert_debt Debt.first, @debt_one
  end

  test 'create new debt with one contact' do
    @debt_one[:party] << ',local-001'
    sync_back = DebtSync.sync([@debt_one], @current_user)
    assert_not_empty sync_back
    assert_equal Debt.all.size, 1
    assert_equal Subscribe.all.size, 1
    assert_debt Debt.first, @debt_one
  end

  test 'update debt' do
    sync_back = DebtSync.sync([@debt_one], @current_user)
    assert_not_empty sync_back
    @debt_one[:id] = sync_back.first[:id]
    @debt_one[:title] = 'Two Pizza'
    sync_back = DebtSync.sync([@debt_one], @current_user)
    assert_empty sync_back
    assert_equal Debt.all.size, 1
    assert_equal Subscribe.all.size, 1
    assert_debt Debt.first, @debt_one
  end

  test 'create debt with 2 users' do
    @debt_one[:party] << ',' + @user_one.id
    sync_back = DebtSync.sync([@debt_one], @current_user)
    assert_not_empty sync_back
    assert_equal Debt.all.size, 1
    assert_equal Subscribe.all.size, 2
    # Check correct subscription create
    current_user_subscribe = Subscribe.find_by(user_id: @current_user.id)
    assert current_user_subscribe.present?
    assert current_user_subscribe.sync

    user_one_subscribe = Subscribe.find_by(user_id: @user_one.id)
    assert user_one_subscribe.present?
    assert_not user_one_subscribe.sync

    assert_debt Debt.first, @debt_one
  end

  private

  def assert_debt(debt, hash)
    assert_equal debt.title, hash[:title]
    assert_party debt.split_party, hash[:party].split(',')
    assert_equal debt.currency, hash[:currency]
    assert_not_nil debt.creator
  end

  def assert_party(debt_party, hash_party)
    difference = hash_party - debt_party
    assert false unless difference.empty?
    # difference.each do |party_id|
    #   (assert false) && return unless party_id =~ /^local/
    #   contact = Contact.find_by internal_id: party_id
    #   assert contact.present?
    #   assert debt_party.index_of(contact.mapped.id).present?
    # end
  end
end