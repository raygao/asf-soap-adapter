require 'test_helper'

class Salesforce::EntitySubscriptionTest < ActiveSupport::TestCase
  def test_should_return_entity_subscriptions
    # see 'test_helper.rb' for USERID, PASSWORD, and SECURITY_TOKEN
    # Salesforce::SfBase.login(USERID, PASSWORD, SECURITY_TOKEN)
    user = Salesforce::User.first

    entity_subscriptions = Array.new
    entity_subscriptions = Salesforce::EntitySubscription.find(:all, :limit => 100).count
    assert_not_nil entity_subscriptions
  end
end
