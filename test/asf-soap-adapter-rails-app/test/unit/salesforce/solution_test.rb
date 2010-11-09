require 'test_helper'

class Salesforce::SolutionTest < ActiveSupport::TestCase
  def test_should_return_solutions
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    solutions = Array.new
    solutions = Salesforce::Solution.find(:all).count
    assert_not_nil solutions
  end
  
end
