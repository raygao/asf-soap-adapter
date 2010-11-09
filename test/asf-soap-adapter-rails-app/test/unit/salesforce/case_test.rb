require 'test_helper'

class Salesforce::CaseTest < ActiveSupport::TestCase
  def test_should_return_cases
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    cases = Array.new
    cases = Salesforce::Case.find(:all).count
    assert_not_nil cases
  end
end