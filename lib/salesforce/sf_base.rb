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

# Salesforce package contains convenience classes for mapping Salesforce objects into
# ActiveRecord objects. The SfBase is the mother of all other objects. Additionally,
# SfUtitlity class provides several useful methods for manipulating SF objects.
module Salesforce
  # SfBase is the mother of all other objects. It establishes the SOAP connection
  # to Salesforce Server and turns it into A/R objects.
  # Main methods are:
  #   1. self.loging (username, password, security_token) -> static method
  #   2. logout (session {as both single or hash}) -> instance method
  #   3. self.swap_connction(connection) -> static method
  #   4. self.query_by_sql(sql) -> static method
  # For complete list of Salesforce Standard Objects in V20.
  class SfBase < ActiveRecord::Base
    self.abstract_class = true

    # By default the 'salesforce-default-realm' in the 'database.yml' is the default
    # connection, meaning all Salesforce objects will use that for the A/R connection.
    # However, a web application is designed to support multiple users. Therefore,
    # each user should have his/her own connection. To do that, the web-application
    # should use the 'before-filter' to swap contexts/connections for each user.
    # A good place to put that filter is in the 'application_controller.rb' file.
    # The context can be changed for 1) a single SF class. Or 2) the root (SfObject),
    # it will affect every other class inherited from the SfObject.
    def self.login(user, pass, token)
      params = {:adapter => "activesalesforce",
        :url => "https://login.salesforce.com/services/Soap/u/20.0",
        :username => user,
        :password => pass + token
      }
      self.establish_connection(params)
    end

    # Logs out of the Salesforce session
    def logout(session_ids=Hash.new)
      result = SfBase.connection.binding.invalidateSessions(session_ids)
      if"invalidateSessionsResponse" == result.to_s
        return true
      else
        return false
      end
      #result this.connection.binding.logout(Hash.new)
    end

    establish_connection "salesforce-default-realm"
  
    set_table_name 'salesforce_sf_bases'

    # Swaps the connection to Salesforce
    def self.swap_connection (connection)
      @@connection = connection
    end

    #Provides a method to directly call SQL via RFORCe
    def self.query_by_sql(sql)
      query_results = connection.binding.query :searchString => sql
      return query_results.queryResponse.result.records unless query_results.queryResponse.result.size < 1 
    end

    attr_reader :current_connection, :connection_owner, :current_connection_binding

    # Return a read only version of the current_connection
    def current_connection
      connection
    end

    # Returns the owner's info of the current Salesforce WS connection
    def connection_owner
      connection.get_user_info
    end

    # Return a read-only version of the binding associated with the current connection
    def current_connection_binding
      connection.binding
    end
 
  end
end