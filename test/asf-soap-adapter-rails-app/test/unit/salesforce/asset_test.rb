require 'test_helper'

class Salesforce::AssetTest < ActiveSupport::TestCase
  def test_should_return_assets
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    #Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    assets = Array.new
    assets = Salesforce::AccountFeed.find(:all).count
    assert_not_nil assets
  end
end
