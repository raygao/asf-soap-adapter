require 'test_helper'

class Salesforce::OpportunityTest < ActiveSupport::TestCase
  def test_should_return_opportunities
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    opportunities = Array.new
    opportunities = Salesforce::Opportunity.find(:all).count
    assert_not_nil opportunities
  end
end
