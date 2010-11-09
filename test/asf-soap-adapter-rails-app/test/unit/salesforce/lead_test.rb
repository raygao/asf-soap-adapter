require 'test_helper'

class Salesforce::LeadTest < ActiveSupport::TestCase
  def test_should_return_leads
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    leads = Array.new
    leads = Salesforce::Lead.find(:all).count
    assert_not_nil leads
  end

  def test_a_with_yaml
    @@config = YAML.load_file(File.dirname(__FILE__) + '/../../../config/database.yml').symbolize_keys
    setting = @@config[:"salesforce-default-realm"]
    url = setting["url"]
    userid = setting["username"]
    password = setting["password"]
    api_version = setting["api_version"]

    #use key file
    @binding = RForce::Binding.new url + "/services/Soap/u/" + api_version.to_s #'https://login.salesforce.com/services/Soap/u/20.0'
    @binding.login userid, (password)
    
    query_results = @binding.query :searchString => "SELECT LeadSource, COUNT(Name) FROM Lead GROUP BY LeadSource"
    results = query_results.queryResponse.result.records
    assert !results.empty?
  end


  def test_lead_with_group_by_clause
    # Using Query_by_sql method of SfBase
    another = Salesforce::SfBase.query_by_sql("SELECT LeadSource, COUNT(Name) FROM Lead GROUP BY LeadSource")
    assert another.size

    zero_result = Salesforce::SfBase.query_by_sql("SELECT Name, Count(Id) FROM Account GROUP BY Name HAVING Count(Id) > 100")
    assert_nil zero_result
  end
end
