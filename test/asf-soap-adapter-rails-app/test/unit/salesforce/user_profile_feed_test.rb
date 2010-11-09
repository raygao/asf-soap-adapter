require 'test_helper'

class Salesforce::UserProfileFeedTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# TODO need to address the issue of "with UserId='xxxxxxx'
# ActiveSalesforce::ASFError: MALFORMED_QUERY: UserProfileFeed queries must include a 'WITH UserId = user-id' clause
