require 'test_helper'

class Salesforce::AccountFeedTest < ActiveSupport::TestCase
  def test_should_return_account_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN

    #Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    account_feeds = Array.new
    account_feeds = Salesforce::AccountFeed.find(:all).count

    assert_not_nil account_feeds
  end

end
