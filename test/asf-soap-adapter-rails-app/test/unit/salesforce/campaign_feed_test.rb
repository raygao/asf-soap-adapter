require 'test_helper'

class Salesforce::CampaignFeedTest < ActiveSupport::TestCase
  def test_should_return_campaign_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    campaign_feeds = Array.new
    campaign_feeds = Salesforce::CampaignFeed.find(:all).count
    assert_not_nil campaign_feeds
  end
end
