require 'test_helper'

class Salesforce::NewsFeedTest < ActiveSupport::TestCase
  def test_should_return_news_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    news_feeds = Array.new
    news_feeds = Salesforce::NewsFeed.find(:all, :limit => 100).count
    assert_not_nil news_feeds
  end
end
