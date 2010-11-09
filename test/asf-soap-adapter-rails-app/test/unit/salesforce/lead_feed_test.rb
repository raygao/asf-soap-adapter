require 'test_helper'

class Salesforce::LeadFeedTest < ActiveSupport::TestCase
  def test_should_return_lead_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    lead_feeds = Array.new
    lead_feeds = Salesforce::LeadFeed.find(:all).count
    assert_not_nil lead_feeds
  end
end
