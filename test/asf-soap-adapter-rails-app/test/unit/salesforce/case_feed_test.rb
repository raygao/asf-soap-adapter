require 'test_helper'

class Salesforce::CaseFeedTest < ActiveSupport::TestCase
  def test_should_return_case_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    case_feeds = Array.new
    case_feeds = Salesforce::CaseFeed.find(:all).count
    assert_not_nil case_feeds
  end
end
