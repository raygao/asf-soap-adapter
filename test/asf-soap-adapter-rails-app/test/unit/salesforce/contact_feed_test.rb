require 'test_helper'

class Salesforce::ContactFeedTest < ActiveSupport::TestCase
  def test_should_return_contact_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    contact_feeds = Array.new
    contact_feeds = Salesforce::ContactFeed.find(:all).count
    assert_not_nil contact_feeds
  end
end
