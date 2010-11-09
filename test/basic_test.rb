=begin
  ActiveSalesforce
  Copyright 2006 Doug Chasman
 
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

require 'rubygems'

#require_gem 'activesalesforce'
require File.dirname(__FILE__) + '/../../lib/active_record/connection_adapters/activesalesforce_adapter'

require File.dirname(__FILE__) + '/recorded_test_case'
require 'pp'

module Salesforce
  class Contact < ActiveRecord::Base
  end

  class Department < ActiveRecord::Base
  end

  class Address < ActiveRecord::Base
  end
end


module Asf
  module UnitTests
    
    class BasicTest < Test::Unit::TestCase
      include RecordedTestCase
      
      attr_reader :contact
      
      def initialize(test_method_name)
        super(test_method_name)
        
        #force_recording :test_create_a_contact
      end
      
      def setup
        puts "\nStarting test '#{self.class.name.gsub('::', '')}.#{method_name}'"

        super

        contact = Salesforce::Contact.new
        
        reset_header_options
        
        contact.first_name = 'DutchTestFirstName'
        contact.last_name = 'DutchTestLastName'
        contact.home_phone = '555-555-1212'
        result = contact.save
        
        newresult = contact.reload
      end
      
      def teardown
        reset_header_options
      
        contact.destroy if contact

        super
      end
      
      def reset_header_options
        binding = Salesforce::Contact.connection.binding
        binding.assignment_rule_id = nil
        binding.use_default_rule = false
        binding.update_mru = false
        binding.trigger_user_email = false    
      end


      def test_create_a_contact
        contact.id
      end

      def test_count_contacts
        assert Salesforce::Contact.count > 0
      end
      
      def test_save_a_contact
        contact.id
      end

      def test_find_a_contact
        c = Salesforce::Contact.find(contact.id)
        assert_equal contact.id, c.id
      end

      def test_find_a_contact_by_id
        c = Salesforce::Contact.find_by_id(contact.id)
        assert_equal contact.id, c.id
      end

      def test_find_a_contact_by_first_name
        c = Salesforce::Contact.find_by_first_name('DutchTestFirstName')
        assert_equal contact.id, c.id
      end
      
      def test_read_all_content_columns
        Salesforce::Contact.content_columns.each { |column| contact.send(column.name) }
      end
            
      def test_get_created_by_from_contact
        user = contact.created_by
        assert_equal contact.created_by_id, user.id
      end
      
      def test_use_update_mru
        Salesforce::Contact.connection.binding.update_mru = true
        contact.save
      end

      def test_use_default_rule
        Salesforce::Contact.connection.binding.use_default_rule = true
        contact.save
      end

      def test_assignment_rule_id
        Salesforce::Contact.connection.binding.assignment_rule_id = "1234567890"
        contact.save
      end
      
      def test_client_id
        Salesforce::Contact.connection.binding.client_id = "testClient"
        contact.save
      end
      
 
      def test_add_notes_to_contact
        n1 = Salesforce::Note.new(:title => "My Title", :body => "My Body")
        n2 = Salesforce::Note.new(:title => "My Title 2", :body => "My Body 2")
        
        contact.notes << n1
        contact.notes << n2
        
        n1.save
        n2.save
      end
      
      def test_master_detail
        department = Salesforce::Department.new(:department_description__c => 'DutchTestDepartment description')
        department.save
        department.reload
        
        job = Job.new(:name => "DutchJob")
        
        department.jobs__c << job
        
        department.destroy
      end

      
      def test_batch_insert
        c1 = Salesforce::Contact.new(:first_name => 'FN1', :last_name => 'LN1')
        c2 = Salesforce::Contact.new(:first_name => 'FN2', :last_name => 'LN2')
        c3 = Salesforce::Contact.new(:first_name => 'FN3', :last_name => 'LN3')

        Salesforce::Contact.transaction(c1, c2) do
          c1.save
          c2.save
        end
        
        c3.save

        c1.first_name << '_2'        
        c2.first_name << '_2'        
        c3.first_name << '_2'        

        Salesforce::Contact.transaction(c1, c2) do
          c1.save
          c2.save
        end
        
        Salesforce::Contact.transaction(c1, c2) do
          c3.save
        
          c3.destroy
          c2.destroy
          c1.destroy
        end
      end
      
      def test_find_addresses
        adresses = Salesforce::Address.find(:all)
      end
                  
    end

  end
end