require 'test_helper'

class Salesforce::SolutionFeedTest < ActiveSupport::TestCase
  def test_should_return_solution_feeds
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    solution_feeds = Array.new
    solution_feeds = Salesforce::SolutionFeed.find(:all).count
    assert_not_nil solution_feeds
  end
end
