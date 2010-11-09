require 'test_helper'

class Salesforce::ContactTest < ActiveSupport::TestCase
  def test_should_return_contacts
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    contacts = Array.new
    contacts = Salesforce::Contact.find(:all).count
    assert_not_nil contacts
  end

end