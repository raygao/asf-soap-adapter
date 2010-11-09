require 'test_helper'

class Salesforce::UserTest < ActiveSupport::TestCase

  def test_should_return_sf_user
    # see test_helper for USERID, PASSWORD, and SECURITY_TOKEN

    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    #Salesforce::User.login(user, password, key)
    num_of_user = Salesforce::User.all.count
    puts "The number of users: " + num_of_user.to_s

    assert_not_nil num_of_user
    #u = Salesforce::User.first
    first_user = Salesforce::User.first
    puts "The first user is: " + first_user.first_name + " " + first_user.last_name
    assert_not_nil first_user
  end

  def test_try_logout

    #sid = Array.new
    #sid[0] = Salesforce::SfBase.connection.binding.instance_variable_get(:@session_id)
    # --> results = Salesforce::User.connection.binding.logout(Hash.new(:sid_key => sid))
    #result = Salesforce::SfBase.connection.binding.invalidateSessions(sid)
    #assert_equal("invalidateSessionsResponse", result.to_s)
    #puts "result: " + result.to_s

    sids = Array.new
    sids[0] = Salesforce::SfBase.connection.binding.instance_variable_get(:@session_id)
    sf_user = Salesforce::User.new()
    # result = sf_user.logout(sids) # logout a particular session
    result = sf_user.logout # test current user
    assert result
  end

end
