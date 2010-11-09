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
  # See http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_objects_list.htm
  # For complete list of Salesforce Standard Objects in V20.
  class Solution < SfBase
    set_table_name 'solutions'
  end
end