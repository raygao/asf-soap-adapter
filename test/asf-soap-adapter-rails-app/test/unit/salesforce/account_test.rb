require 'test_helper'

class Salesforce::AccountTest < ActiveSupport::TestCase
  # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN

  def test_find_accounts_with_rforce
    ##Test case with RFace
    #@binding = RForce::Binding.new 'https://login.salesforce.com/services/Soap/u/20.0'
    #@binding.login USERID, (PASSWORD + SECURITY_TOKEN)

    @@config = YAML.load_file(File.dirname(__FILE__) + '/../../../config/database.yml').symbolize_keys
    setting = @@config[:"salesforce-default-realm"]
    url = setting["url"]
    userid = setting["username"]
    password = setting["password"]
    api_version = setting["api_version"]

    #use key file
    @binding = RForce::Binding.new url + "/services/Soap/u/" + api_version.to_s #'https://login.salesforce.com/services/Soap/u/20.0'
    @binding.login userid, (password)

    answer = @binding.search :searchString => "find {Arizona} in name fields returning account(id, phone)"
    assert_not_nil answer
  end

  def test_find_accounts_with_rforce_by_name_and_description
    ##Test case with RFace
    #@binding = RForce::Binding.new 'https://login.salesforce.com/services/Soap/u/20.0'
    #@binding.login USERID, (PASSWORD + SECURITY_TOKEN)

    @@config = YAML.load_file(File.dirname(__FILE__) + '/../../../config/database.yml').symbolize_keys
    setting = @@config[:"salesforce-default-realm"]
    url = setting["url"]
    userid = setting["username"]
    password = setting["password"]
    api_version = setting["api_version"]

    #use key file
    @binding = RForce::Binding.new url + "/services/Soap/u/" + api_version.to_s #'https://login.salesforce.com/services/Soap/u/20.0'
    @binding.login userid, (password)

    name = 'company'

    @results = @binding.search :searchString => "find {#{name}} in all fields returning account(id, phone)"
    assert_not_nil @results
  end

  def test_should_return_account
    account = Salesforce::Account.first
    assert_not_nil account
  end

  def test_create_and_delete_account
    account = Salesforce::Account.new
    account[:first_name] = "abcdefg"
    account[:last_name] = '67890'
    account[:name] = '1234567890'
    account.save

    readback = Salesforce::Account.find_by_name('1234567890')
    assert_not_nil readback
    # cleaning up
    Salesforce::SfBase.delete(readback.id)    
  end

end
