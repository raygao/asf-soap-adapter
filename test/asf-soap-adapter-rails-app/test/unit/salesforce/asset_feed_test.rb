require 'test_helper'

class Salesforce::AssetFeedTest < ActiveSupport::TestCase
  def test_should_return_asset_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    #Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    asset_feeds = Array.new
    asset_feeds = Salesforce::AssetFeed.find(:all).count

    assert_not_nil asset_feeds
  end
end
