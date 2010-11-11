require 'test_helper'
#require RAILS_ROOT + '/lib/asf/activerecord-activesalesforce-adapter'

class Salesforce::ChatterFeedTest < ActiveSupport::TestCase
  def notest_get_chatter_feed_without_content_file
    user = Salesforce::User.first
    chatter_feed_finder = Salesforce::ChatterFeed.new
    account_feed = Salesforce::AccountFeed.first

    object_id = account_feed.id
    feed_no_attachment = chatter_feed_finder.get_all_chatter_feeds_without_attachments(object_id, 'Account', user.connection.binding, 'test-session-id')
    assert feed_no_attachment
  end

  def notest_get_chatter_feed_with_content_file
    user = Salesforce::User.first
    chatter_feed_finder = Salesforce::ChatterFeed.new
    #account_feed = Salesforce::AccountFeed.first
    dir_name = 'test-session-id'

    #object_id = account_feed.id
    #chatter_feed_with_attachment = chatter_feed_finder.get_all_chatter_feeds_with_attachments('001A0000009ZtSkIAK', 'Account', user.connection.binding, dir_name)
    query_conditions = ["type = :type", {:type => "ContentPost"}]
    sfutility = Salesforce::SfUtility.new
    results = Salesforce::SfUtility.salesforce_object_find_by_type_and_conditions("AccountFeed", query_conditions)
    results.each do |res|
      chatter_feed_with_attachment = chatter_feed_finder.get_all_chatter_feeds_with_attachments(res.parent_id, 'Account', user.connection.binding, dir_name)
    #  assert !chatter_feed_with_attachment.empty?
    end

    assert !results.empty?
  end

  # testing against search feature of the ChatterFeed class.
  def test_search_chatter_feed
    user = Salesforce::User.first

    message = Time.now.to_s + ': a new message'
    user.current_status = message
    user.save

    chatter_feed_finder = Salesforce::ChatterFeed.new

    query_string = message
    search_results = chatter_feed_finder.search_chatter_feeds('User', query_string, user.connection.binding)
    assert search_results
    # Cleaning up.
    result = Salesforce::SfBase.delete(search_results.last.Id)
  end



end
