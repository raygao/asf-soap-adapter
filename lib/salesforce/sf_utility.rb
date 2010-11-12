=begin
asf-soap-adapter
Copyright 2010 Raymond Gao

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end


module Salesforce
  #This is the utility class for managing Salesforce objects.
  class SfUtility
    # SalesObject KeyPrefix 3 digits code => Object Type locator.
    # ID   Prefix	Entity Type
    # (Following has associated ChatterFeed {object}Feed
    #   001	Account
    #   02i Asset
    #   500 Case
    #   701	Campaign
    #   003	Contact
    #   800 Contract
    #   00G Group
    #   00Q	Lead
    #   006	Opportunity
    #   00D	Organization
    #   01t Product2
    #   501 Solution
    #   00T Task
    #   005	User
    #
    #   (Special Feed class, with no associated SF object)
    #   0D5 NewsFeed is special, It does not have SF Object
    #
    #   (Other Chatter Object without Feed)
    #   00V	Campaign Member
    #   00e	Profile
    #   00N	Custom Field Definition
    #
    # (FeedItem vs. FeedPost)
    #  0D5  FeedItem (post by everyone)
    #  0F7  FeedPost (post made by this user)
    #
    # See: http://eng.genius.com/blog/2009/05/17/salesforcecom-api-gotchas-2/
    SFObjectPrefix = {
      '001' => 'Account',
      '02i' => 'Asset',
      '500' => 'Case',
      '701' => 'Campaign',
      '003' => 'Contact',
      '800' => 'Contract',
      '00G' => 'Group',
      '00Q' => 'Lead',
      '006' => 'Opportunity',
      '00D' => 'Organization',
      '01t' => 'Product2',
      '501' => 'Solution',
      '00T' => 'Task',
      '005' => 'User',
      # below are other Salesforce object without chatter {object}Feed
      '00V' => 'Campaign Member',
      '00E' => 'Profile',
      '00N' => 'Custom_Field_Definition',
      #distinction between FeedItem and FeedPost
      '0D5' => 'FeedItem',
      '0F7' => 'FeedPost',
      'xxx' => 'Unknown',
      '' => 'Unknown'
    }

    # Determine the Salesforce object type based on 3-digits OID prefix.
    def self.determine_sf_object_type(id)
      String oid = id[0,3]
      if SFObjectPrefix.has_key?(oid)
        return SFObjectPrefix.value(oid)
      else
        return 'Unknown'
      end
    end


    # Finders the appropriate Salesforce Object based on Object. No more guess work.
    # <em>nil</em> means that the <em>oid</em> is not supported by this method, e.g. not suitable.
    def self.salesforce_object_find_by_id (oid)
      query_conditions = Hash.new
      query_conditions[:id] = oid

      otype = determine_sf_object_type(oid)
      if otype != 'Unknown'
        sf_object = salesforce_object_find_all(otype, query_conditions).first
      else
        sf_object = nil
      end

      return sf_object
    end

    # Finders the appropriate Salesforce Object based on Object Type and description
    # <em>nil</em> means that the <em>oid</em> is not supported by this method, e.g. not suitable.
    def self.salesforce_object_find_by_type_and_conditions (otype, query_conditions)
      # for example
      #Salesforce::Group.find(:all, :conditions => ["email like :search", {:search => '%.com'}])
      sf_objects = salesforce_object_find_all(otype, query_conditions)

      return sf_objects
    end

    # Finders the appropriate Salesforce Object based on the Object Type
    # returning <em>nil</em> means that the <em>oid</em> is not supported by this method, e.g. not suitable.
    def self.salesforce_object_find_all(otype, query_conditions = nil)
      case otype
      when 'Account'
        sf_object = Salesforce::Account.find(:all, :conditions => query_conditions)
      when 'AccountFeed'
        sf_object = Salesforce::AccountFeed.find(:all, :conditions => query_conditions)
      when 'Asset'
        sf_object = Salesforce::Asset.find(:all, :conditions => query_conditions)
      when 'AssetFeed'
        sf_object = Salesforce::AssetFeed.find(:all, :conditions => query_conditions)
      when 'Case'
        sf_object = Salesforce::Case.find(:all, :conditions => query_conditions)
      when 'CaseFeed'
        sf_object = Salesforce::CaseFeed.find(:all, :conditions => query_conditions)
      when 'Campaign'
        sf_object = Salesforce::Campaign.find(:all, :conditions => query_conditions)
      when 'CampaignFeed'
        sf_object = Salesforce::CampaignFeed.find(:all, :conditions => query_conditions)
      when 'Contact'
        sf_object = Salesforce::Contact.find(:all, :conditions => query_conditions)
      when 'ContactFeed'
        sf_object = Salesforce::ContactFeed.find(:all, :conditions => query_conditions)
      when 'Contract'
        sf_object = Salesforce::Contract.find(:all, :conditions => query_conditions)
      when 'ContractFeed'
        sf_object = Salesforce::ContractFeed.find(:all, :conditions => query_conditions)
      when 'Group'
        sf_object = Salesforce::Group.find(:all, :conditions => query_conditions)
      when 'Lead'
        sf_object = Salesforce::Lead.find(:all, :conditions => query_conditions)
      when 'LeadFeed'
        sf_object = Salesforce::LeadFeed.find(:all, :conditions => query_conditions)
      when 'Opportunity'
        sf_object = Salesforce::Opportunity.find(:all, :conditions => query_conditions)
      when 'OpportunityFeed'
        sf_object = Salesforce::OpportunityFeed.find(:all, :conditions => query_conditions)
      when 'Organization'
        sf_object = Salesforce::Organization.find(:all, :conditions => query_conditions)
      when 'Product2'
        sf_object = Salesforce::Product2.find(:all, :conditions => query_conditions)
      when 'Product2Feed'
        sf_object = Salesforce::Product2Feed.find(:all, :conditions => query_conditions)
      when 'Solution'
        sf_object = Salesforce::Solution.find(:all, :conditions => query_conditions)
      when 'SolutionFeed'
        sf_object = Salesforce::SolutionFeed.find(:all, :conditions => query_conditions)
      when 'User'
        sf_object = Salesforce::User.find(:all, :conditions => query_conditions)
      when 'UserFeed'
        sf_object = Salesforce::UserFeed.find(:all, :conditions => query_conditions)
      else
        sf_object = nil
      end

      return sf_object
    end

    # Create a blank Salesforce Object based on the object type.
    def self.salesforce_object_create(otype)
      case otype
      when 'Account'
        sf_object = Salesforce::Account.new()
      when 'Asset'
        sf_object = Salesforce::Asset.new()
      when 'Case'
        sf_object = Salesforce::Case.new()
      when 'Campaign'
        sf_object = Salesforce::Campaign.new()
      when 'Contact'
        sf_object = Salesforce::Contact.new()
      when 'Contract'
        sf_object = Salesforce::Contract.new()
      when 'Group'
        sf_object = Salesforce::Group.new()
      when 'Lead'
        sf_object = Salesforce::Lead.new()
      when 'Opportunity'
        sf_object = Salesforce::Opportunity.new()
      when 'Organization'
        sf_object = Salesforce::Organization.new()
      when 'Product2'
        sf_object = Salesforce::Product2.new()
      when 'Solution'
        sf_object = Salesforce::Solution.new()
      when 'User'
        sf_object = Salesforce::User.new()

      else
        sf_object = nil
      end

      return sf_object
    end
    
  end

end
