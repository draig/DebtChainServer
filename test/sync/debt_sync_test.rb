require 'test_helper'

class DebtSyncTest < ActiveSupport::TestCase
  def setup
    @current_user = User.create! name: 'John Doe', phone: '+0000001'
    @debt_one = { id: 'local-001', title: 'Pizza', party: @current_user.id.to_s,
                  currency: 'usd' }
  end

  test 'create new debt' do
    sync_back = DebtSync.sync([@debt_one], @current_user)
    assert_not_empty sync_back
    assert_equal Debt.all.size, 1
    assert_debt Debt.first, @debt_one
  end

  private

  def assert_debt(debt, hash)
    assert_equal debt.title, hash[:title]
    #assert_empty debt.party.split(',') - hash[:party].split(',')
    assert_equal debt.currency, hash[:currency]
    assert_not_nil debt.creator
  end
end