require 'test_helper'

class Salesforce::Product2FeedTest < ActiveSupport::TestCase
  def test_should_return_product2_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    product2_feeds = Array.new
    product2_feeds = Salesforce::Product2Feed.find(:all).count
    assert_not_nil product2_feeds
  end
end
