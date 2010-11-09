require 'test_helper'

class Salesforce::UserFeedTest < ActiveSupport::TestCase
  def test_should_return_user_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    user_feeds = Array.new
    user_feeds = Salesforce::UserFeed.find(:all).count
    assert_not_nil user_feeds
  end
end
