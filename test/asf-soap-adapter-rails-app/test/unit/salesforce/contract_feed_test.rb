require 'test_helper'

class Salesforce::ContractFeedTest < ActiveSupport::TestCase
  def test_should_return_contract_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    contract_feeds = Array.new
    contract_feeds = Salesforce::ContractFeed.find(:all).count
    assert_not_nil contract_feeds
  end
end
