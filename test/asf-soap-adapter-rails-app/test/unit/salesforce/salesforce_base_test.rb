require 'test_helper'

class Salesforce::SfBaseTest < ActiveSupport::TestCase
  # see test_helper for USERID, PASSWORD, and SECURITY_TOKEN
  def test_should_connect
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    u = Salesforce::User.first
    assert_not_nil u
  end
end
