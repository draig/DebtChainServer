require_relative 'debt_sync'
require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @debt_sync = DebtSync.new
  end

  test 'create new contact' do
    Debt.delete_all
    DebtSync
    assert true
  end
end
