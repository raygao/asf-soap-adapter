require 'rubygems'
require 'active_record'
require 'active_resource'

require 'pp'
require File.dirname(__FILE__) + '/../lib/active_record/connection_adapters/activesalesforce_adapter'
require File.dirname(__FILE__) + '/recorded_test_case'


module Salesforce
  class SfBase < ActiveRecord::Base
    self.logger

    #takes parameter from the config_file
    def self.login(user, pass, token)
      params = {:adapter => "activesalesforce",
        :url => "https://www.salesforce.com",
        :username => user,
        :password => pass + token
      }
      status = self.establish_connection(params)
      puts "Created SfBase connection: ---> " + status.connection.binding.to_s + "\n"
    end

    def initialize()
      puts "---> SfBase initialized.\n"
    end

#    self.establish_connection @@params
    set_table_name 'salesforce_sf_base'
  end

  class Account < SfBase
    set_table_name 'account'
    puts "Account Self.name ---> " + self.name
    puts "Account.table_name ==> " + self.table_name
  end
end

module UnitTests
  class SimpleTest < Test::Unit::TestCase

    @@config = YAML.load_file(File.dirname(__FILE__) + '/config.yml').symbolize_keys
    @@sf_setting = {
      :adapter => @@config[:adapter],
      :url => @@config[:url],
      :username => @@config[:username],
      :password => @@config[:password] + @@config[:security_token],
    }
      
    def setup
      #puts "\nStarting test '#{self.class.name.gsub('::', '')}.#{method_name}'"
      super
      Salesforce::SfBase.login(@@config[:username], @@config[:password], @@config[:security_token])
    end
    
    def test_find_account
      account = Salesforce::Account.find(:first)
      puts "SF account name: " + account.name

      assert account
    end
  end
 
end
