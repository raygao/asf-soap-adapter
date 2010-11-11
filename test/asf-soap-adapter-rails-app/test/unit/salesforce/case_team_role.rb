require 'test_helper'

class Salesforce::CaseTeamRoleTest < ActiveSupport::TestCase
  def test_should_return_result
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    #Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    result = Salesforce::CaseTeamRole.columns
    assert_not_nil result
  end
end
