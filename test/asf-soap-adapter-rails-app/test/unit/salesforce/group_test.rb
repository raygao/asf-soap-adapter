require File.dirname(__FILE__) + '/../../test_helper'

class Salesforce::GroupTest < ActiveSupport::TestCase

  def test_should_return_groups
    groups = Array.new
    groups = Salesforce::Group.find(:all).count
    assert_not_nil groups
  end

  def test_should_return_groups
    agroup = Salesforce::Group.last
    created_by = agroup.created_by_id
    id = agroup.id.to_s
    #query_conditions = ["id = :id and email like :match_string", {:match_string => "%" +  email + "%", :id => id }]
    query_conditions = ["id = :id and created_by_id = :match_string", {:match_string => created_by, :id => id }]

    results = Salesforce::SfUtility.salesforce_object_find_by_type_and_conditions("Group", query_conditions)

    assert !results.empty?
  end
end


