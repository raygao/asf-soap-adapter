require 'test_helper'

class Salesforce::CampaignTest < ActiveSupport::TestCase
  def test_should_return_campaigns
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    campaigns = Array.new
    campaigns = Salesforce::Campaign.find(:all).count
    assert_not_nil campaigns
  end
end
