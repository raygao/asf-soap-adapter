require 'logger'
module Salesforce
  # ==This is the abstract to the 'XXXFeed' table in Salesforce Chatter
  #
  # Note: FeedPost cannot be directly queried. It must go through its parent. For example:
  # <i>SELECT Id, Type, FeedPost.Body FROM AccountFeed WHERE ParentId = AccountId ORDER BY CreatedDate DESC</i>
  #
  # SalesObject's 3 digits code for the KeyPrefix:
  #  ID   Prefix	Entity Type
  #  001	Account
  #  006	Opportunity
  #  003	Contact
  #  00Q	Lead
  #  701	Campaign
  #  00V	Campaign Member
  #  00D	Organization
  #  005	User
  #  00E	Profile
  #  00N	Custom Field Definition
  #
  #  0D5  FeedItem (post by everyone)
  #  0F7  FeedPost (post made by this user)
  # See: http://eng.genius.com/blog/2009/05/17/salesforcecom-api-gotchas-2/
  class ChatterFeed
    def initialize
      #### define @logger
      # http://ruby-doc.org/core/classes/@logger.html
      # TODO use a log file, rather than Standout
      @logger = Logger.new(STDOUT)
      #@logger.level = @logger::WARN
    end

    #fields do
    #  timestamps
    #end

    BASE_FRAG = "Id, CreatedDate, Type, CreatedBy.Name, CreatedBy.Id"

    FEEDPOST_WITH_CONTENT_DATA_FRAG = <<-HERE
    FeedPost.Id, FeedPost.FeedItemId, FeedPost.ParentId, FeedPost.Type,
    FeedPost.CreatedById, FeedPost.CreatedDate, FeedPost.SystemModStamp,
    FeedPost.Title, FeedPost.Body, FeedPost.LinkUrl,
    FeedPost.ContentData, FeedPost.ContentFileName, FeedPost.ContentDescription,
    FeedPost.ContentType, FeedPost.ContentSize
    HERE

    FEEDPOST_WITHOUT_CONTENT_DATA_FRAG = <<-HERE
    FeedPost.Id, FeedPost.FeedItemId, FeedPost.ParentId, FeedPost.Type,
    FeedPost.CreatedById, FeedPost.CreatedDate, FeedPost.SystemModStamp,
    FeedPost.Title, FeedPost.Body, FeedPost.LinkUrl, FeedPost.ContentSize
    HERE

    CREATOR_FRAG = "CreatedBy.FirstName, CreateBy.LastName, CreatedBy.Id"

    FEED_TRACKED_CHANGE_FRAG = <<-HERE
    Select Id, FieldName, OldValue, NewValue From FeedTrackedChanges
      ORDER BY Id Desc
    HERE

    FEED_COMMENT_FRAG = <<-HERE
    Select Id, CommentBody, CreatedDate, CreatedBy.Id, CreatedBy.FirstName,
      CreatedBy.LastName FROM FeedComments ORDER BY CreatedDate
    HERE

    # find all chatter feeds based on object_type, query_string, and given binding
    def search_chatter_feeds(object_type, query_string, binding, limit=100)
      return get_all_chatter_feeds_with_attachments(nil, object_type, binding, 'no-attachment-for-search', limit, false, query_string)
    end

    # 1. It does not return the attached file.
    # 2. See get_all_feed_posts_with_attachments(object_id, object_type, binding, directory_name, limit=100, get_attachment=true, query_string=nil)
    # 7. returns Ruby Array of matching records
    def get_all_chatter_feeds_without_attachments(object_id, object_type, binding, directory_name, limit=100)
      return get_all_chatter_feeds_with_attachments(object_id, object_type, binding, directory_name, limit, false, nil)
    end

    # 1. It returns the attached file.
    # 2. <b>'object_id'</b> corresponds to the 'parent_id' column in the 'XXXFeed' table
    # 3. <b>'object_type'</b> can be one of the followings
    #     Account, Asset, Campaign, Case, Lead, Contact, Contract, Opportunity,
    #     Product2, Solution, User
    #     **Note**: UserProfileFeed and NewsFeed are special cases.
    #       UserProfileFeed  -> select ... from UserProfileFeed with Userid='userid'
    #       NewsFeed -> select ... from NewsFeed where parentid = 'userid'
    # 4. <b>'binding'</b> can be passed in directly or using the inherited binding from the
    #    'Salesforce::SfBase' base class.
    # 5. <b>'directory_name</b> is the directory in 'public/tmp' for saving the attachment
    # 6. <b>'limit</b> is the number of records to return
    # 7. <b>'get_attachment'</b> is a boolean flag, true gets the attachment,
    #     false does not get the attachment
    # 8. <b>query_string</b> is used to search against the Salesforce. Note, if "object_id' is specified, query_string is ignored.
    # 8. returns Ruby Array of matching records
    # 9. TODO add conditions, e.g.
    #     search -> where FeedPost.CreatedDate > 2007-08-06T03:23:00.000Z and FeedPost.Body like '%post%'
    #     pagination ->

    def get_all_chatter_feeds_with_attachments(object_id, object_type, binding, directory_name, limit=100, get_attachment=true, query_string=nil)
      begin
        #e.g. select Id, type, FeedPost.body from UserProfileFeed WITH UserId = '005A0000000S8aIIAS'
        if !object_id.nil?
          qstring = <<-HERE
          SELECT #{BASE_FRAG}, #{FEEDPOST_WITHOUT_CONTENT_DATA_FRAG},
          (#{FEED_TRACKED_CHANGE_FRAG}), (#{FEED_COMMENT_FRAG} LIMIT #{limit})
          FROM #{object_type}Feed where parentid = \'#{object_id}\'
          ORDER BY CreatedDate DESC limit #{limit}
          HERE
        elsif !query_string.nil?
          # this is more like a search....
          qstring = <<-HERE
          SELECT #{BASE_FRAG}, #{FEEDPOST_WITHOUT_CONTENT_DATA_FRAG},
          (#{FEED_TRACKED_CHANGE_FRAG}), (#{FEED_COMMENT_FRAG} LIMIT #{limit})
          FROM #{object_type}Feed where FeedPost.Body like \'%#{query_string}%\'
          ORDER BY CreatedDate DESC limit #{limit}
          HERE
        else
          qstring = <<-HERE
          SELECT #{BASE_FRAG}, #{FEEDPOST_WITHOUT_CONTENT_DATA_FRAG},
          (#{FEED_TRACKED_CHANGE_FRAG}), (#{FEED_COMMENT_FRAG} LIMIT #{limit})
          FROM #{object_type}Feed ORDER BY CreatedDate DESC limit #{limit}
          HERE
        end


        @logger.info('qstring: ' + qstring)
        # Note, if query FeedPost.ContentData, Salesforce only returns 1 entry at
        # a time, you will get a 'queryLocator', which can be used by calling
        # 'queryMore(queryLocator)'

        feed_results = Array.new

        results = binding.query(:queryString => qstring)
        if results.queryResponse.result.records.is_a?(Hash)
          # User has made only one feedpost
          feed = Hash.new
          feed = results.queryResponse.result.records
          if (!feed.FeedPost.nil?) && (feed.FeedPost.ContentSize.to_i > 0)
            feed = get_single_chatter_feed_with_attachment(feed.FeedPost.Id, feed[:type], binding, directory_name)
          end
          feed_results << feed
        elsif results.queryResponse.result.records.is_a?(Array)
          results.queryResponse.result.records.each do |an_feed_entry|
            if (an_feed_entry.is_a?(Hash))
              if (an_feed_entry[:Type] == "TrackedChange")
                # This is a TrackedChange Feed, the FeedPost Body is nil
                feed = Hash.new
                feed = an_feed_entry
                feed_results << feed
              elsif (!an_feed_entry.FeedPost.nil?) && (an_feed_entry.FeedPost.ContentSize.to_i > 0) && (get_attachment)
                # This signifies that:
                #   1. results.queryResponse.result.records.FeedPost.Type is of "ContentPost"
                #   2. results.queryResponse.result.records.FeedPost.type should be of "FeedPost"
                an_entry_with_attachment = get_single_chatter_feed_with_attachment(an_feed_entry.FeedPost.Id, an_feed_entry[:type], binding, directory_name)
                feed_results << an_entry_with_attachment
              else
                feed = Hash.new
                feed = an_feed_entry
                feed_results << feed
              end
            else
              @logger.info "Result #{object_id} has a results.queryResponse that is either not a valid Hash, or with nil FeedPost."
            end
          end
        end

        #if there are more entries, query it again and show it all
        while results.queryResponse.result.done.to_s.upcase != 'TRUE'
          results = binding.queryMore(:queryString => results.queryResponse.result.queryLocator)
          if results.queryResponse.result.records.is_a?(Hash)
            # User has made only one feedpost
            feed = Hash.new
            feed = results.queryResponse.result.records
            if (!feed.FeedPost.nil?) && (feed.FeedPost.ContentSize.to_i > 0)
              feed = get_single_chatter_feed_with_attachment(feed.FeedPost.Id, feed[:type], binding, directory_name)
            end
            feed_results << feed
          elsif results.queryResponse.result.records.is_a?(Array)
            results.queryResponse.result.records.each do |an_feed_entry|
              if (an_feed_entry.is_a?(Hash))
                if (an_feed_entry[:Type] == "TrackedChange")
                  # This is a TrackedChange Feed, the FeedPost Body is nil
                  feed = Hash.new
                  feed = an_feed_entry
                  feed_results << feed
                  # check to see if it has attachments
                elsif  (!an_feed_entry.FeedPost.nil?) && (an_feed_entry.FeedPost.ContentSize.to_i > 0) && (get_attachment)
                  # This signifies that:
                  #   1. results.queryResponse.result.records.FeedPost.Type is of "ContentPost"
                  #   2. results.queryResponse.result.records.FeedPost.type should be of "FeedPost"
                  an_entry_with_attachment = get_single_chatter_feed_with_attachment(an_feed_entry.FeedPost.Id, an_feed_entry[:type], binding, directory_name)
                  feed_results << an_entry_with_attachment
                else
                  feed = Hash.new
                  feed = an_feed_entry
                  feed_results << feed
                end

              else
                @logger.info "Result #{object_id} has a results.queryResponse that is either an invalid Hash or a nil FeedPost."
              end
            end
          end
        end

        return feed_results
      rescue Exception => exception
        @logger.info 'get_all_feed_posts_with_attachments: ' + exception.message
        return feed_results
      end
    end

    # 1. Returns a single feed with attachment.
    # 2. <b>'feedpost_id</b> is the id corresponding to this feedpost
    # 3. <b>'feed_type'</b> can be one of the followings
    #     Account, Asset, Campaign, Case, Lead, Contact, Contract, Opportunity,
    #     Product2, Solution, User
    #     **Note**: UserProfileFeed and NewsFeed are not included here, as they
    #     are special cases.
    # 4. <b>'binding'</b> can be passed in directly or using the inherited binding from the
    #     'Salesforce::SfBase' base class.
    # 5. <b>'directory_name</b> is the directory in 'public/tmp' for saving the attachment
    # 6. <b>'limit'</b> is the number of feed comments to retrieve at a time
    def get_single_chatter_feed_with_attachment(feedpost_id, feed_type, binding, directory_name, limit=100)
      begin
        expanded_qstring = <<-HERE
        SELECT #{BASE_FRAG}, #{FEEDPOST_WITH_CONTENT_DATA_FRAG},
        (#{FEED_TRACKED_CHANGE_FRAG}), (#{FEED_COMMENT_FRAG} LIMIT #{limit})
        FROM #{feed_type} where FeedPost.Id= \'#{feedpost_id}\' ORDER BY CreatedDate DESC Limit 1
        HERE

        @logger.info('expanded_string: ' + expanded_qstring)
        deep_result = binding.query(:queryString => expanded_qstring)

        ######### queryMore does not work on FeedPost with Content.##########
        # locator = deep_result.queryResponse.result.queryLocator
        # while !locator.nil?
        #  query_again = binding.queryMore(:queryLocator => locator)
        #  locator = query_again.queryMoreResponse.result.queryLocator
        # end
        #####################################################################

        if !deep_result.Fault.nil?
          raise ChatterFeedError.new(@logger, deep_result.Fault.faultstring.to_s)
        end
        if !deep_result.queryResponse.result.records.FeedComments.nil? && deep_result.queryResponse.result.records.FeedComments[:size].to_i > 1
          # There are more than one feed comments. Therefore, search again without content-data.
          # This is done, because having ContentData in the query string, it will only return only the 1st record of the feed comments.
          qstring_without_content_data = <<-HERE
          SELECT #{BASE_FRAG},
          (#{FEED_TRACKED_CHANGE_FRAG}), (#{FEED_COMMENT_FRAG} LIMIT 20)
          FROM #{feed_type} where FeedPost.Id= \'#{feedpost_id}\' ORDER BY CreatedDate DESC Limit 1
          HERE
          result_without_content_data = binding.query(:queryString => qstring_without_content_data)
          list_of_feed_comments = result_without_content_data.queryResponse.result.records.FeedComments
          deep_result.queryResponse.result.records.FeedComments[:records] = list_of_feed_comments[:records]
        end

        filename = deep_result.queryResponse.result.records.FeedPost.ContentFileName
        filesize = deep_result.queryResponse.result.records.FeedPost.ContentSize
        filedata = deep_result.queryResponse.result.records.FeedPost.ContentData
        result_with_attachment = deep_result.queryResponse.result.records

        local_file_name = nil

        if filename.nil?
          # remote filename is nil, do not write the local file
          @logger.info("remote filename is nil, do not write the local file.")
        else
          # Downloaded files are put in the subdirectory matching each session-id in the /public/tmp directory.
          # creates dir, if it does not exists
          file_writer = Salesforce::FileWriter.new
          local_file_name = file_writer.do_write_file(filename, filesize, filedata, directory_name)
          result_with_attachment.FeedPost.store(:Attachment, local_file_name)
        end

        return result_with_attachment
      end
    rescue Exception => exception
      @logger.info "Cannot create the file: " + exception.message
      result_with_attachment.FeedPost[:attachment] = nil
      return result_with_attachment
    end


  end

  class ChatterFeedError < RuntimeError
    def initialize(logger, message)
      super(logger, message)
    end
  end
end