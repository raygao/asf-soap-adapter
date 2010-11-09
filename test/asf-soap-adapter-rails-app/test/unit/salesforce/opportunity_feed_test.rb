require 'test_helper'

class Salesforce::OpportunityFeedTest < ActiveSupport::TestCase
  def test_should_return_opportunity_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    opportunity_feeds = Array.new
    opportunity_feeds = Salesforce::OpportunityFeed.find(:all).count
    assert_not_nil opportunity_feeds
  end
end
