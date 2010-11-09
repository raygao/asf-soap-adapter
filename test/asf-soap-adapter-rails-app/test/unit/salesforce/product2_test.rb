require 'test_helper'

class Salesforce::Product2Test < ActiveSupport::TestCase
  def test_should_return_product2s
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    product2s = Array.new
    product2s = Salesforce::Product2.find(:all).count
    assert_not_nil product2s
  end
end
