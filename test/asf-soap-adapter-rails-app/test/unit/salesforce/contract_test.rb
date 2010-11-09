require 'test_helper'

class Salesforce::ContractTest < ActiveSupport::TestCase
  def test_should_return_contracts
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    contracts = Array.new
    contracts = Salesforce::Contract.find(:all).count
    assert_not_nil contracts
  end
end
