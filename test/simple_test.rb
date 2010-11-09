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
require 'active_record'
require 'active_resource'
#require File.dirname(__FILE__) +  '/../lib/salesforce/file_writer'

require 'pp'
require File.dirname(__FILE__) + '/../lib/active_record/connection_adapters/activesalesforce_adapter'
require File.dirname(__FILE__) + '/../lib/asf-soap-adapter'

require File.dirname(__FILE__) + '/recorded_test_case'


module Salesforce
  class SfBaseline < ActiveRecord::Base
    self.logger
    # replace, with username, password + security_token
    @@params = {
      :adapter => 'activesalesforce',
      :url => 'https://www.salesforce.com',
      :username => '<username>',
      :password => '<password+security_token>',
    }


    def self.login()
      
      status = self.establish_connection(@@params)
      puts "---> SfBaseline login: connection: ---> " + status.connection.binding.to_s
    end

    def initialize()
      puts "---> SfBaseline loaded \n"
    end
    
    self.establish_connection @@params
    set_table_name 'salesforce_sf_bases'
  end
  
  class Account < SfBaseline
    set_table_name 'account'
    puts "Account Self.name ---> " + self.name
    puts "Account.table_name ==> " + self.table_name
  end
end


module UnitTests

  class SimpleTest < Test::Unit::TestCase
    LOGGER = Logger.new(STDOUT)
    ActiveRecord::Base.logger = LOGGER
    # replace, with username, password + security_token
    @@myparams = {
      :adapter => 'activesalesforce',
      :url => 'https://www.salesforce.com',
      :username => '<username>',
      :password => '<password+security_token>',
    }

    def setup
      puts '--- starting simple_test.rb ---'
      super
      Salesforce::SfBaseline.login
      account = Salesforce::Account.find(:first)
      puts "SF account name: " + account.name

      # account.save!
      puts "new user object: " + account.to_s
    end

=begin
    def test_create_filewriter
      fwriter = Salesforce::FileWriter.new
      assert fwriter
    end
=end
  end

end