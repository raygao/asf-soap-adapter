require 'logger'
module Salesforce
  class FileWriter < Object

    def initialize
      super
      #### define @logger
      # http://ruby-doc.org/core/classes/@logger.html
      # TODO use a log file, rather than Standout
      @logger = Logger.new(STDOUT)
      @logger.debug 'FileWriter initialized.'
    end
    
    # This method optimizes the file writing process. If the local file already exists
    # and matchs the remote filesize, it skips writing. Otherwise, it writes the file.
    # <b>returns local_file_name = RAILS_ROOT/public/tmp/<parent_dir>/filename</b>
    #
    # 'filename' the remote filename
    # 'filesize' the size of the remote file
    # 'filedata' contains encoded file data
    # 'parent_dir' the subdirectory where the file will be stored at
    def do_write_file(filename, filesize, filedata, parent_dir)
      # Downloaded files are put in the subdirectory matching each session-id in the /public/tmp directory.
      # creates dir, if it does not exists
      dir = "/tmp/#{parent_dir}"
      # Creating the 'tmp' under the 'public' to hold downloaded files.
      Dir.mkdir(RAILS_ROOT + "/public/tmp" ) unless File.directory?(RAILS_ROOT + "/public/tmp")
      # Putting files in each user's sesseion directory.
      Dir.mkdir(RAILS_ROOT + "/public" + dir ) unless File.directory?(RAILS_ROOT + "/public" + dir)
      local_file_name =  dir + "/#{filename}"

      writefile_flag = true
      #local_file_name =  '/tmp/' + session_id + "-" + filename

      if !File.exist?(RAILS_ROOT + "/public" + local_file_name)
        # local file does not exist, write the local file
        @logger.info("local file does not exist, write the local file.")
        writefile_flag = true
      elsif File.size(RAILS_ROOT + "/public" + local_file_name).to_i == filesize.to_i
        # local file exists & file size matchs remote file sizem, skip writing the local local file
        @logger.info("local file exists & file size matchs remote file sizem, skip writing the local local file.")
        writefile_flag = false
      else
        @logger.info("Write the local file: " + RAILS_ROOT + "/public" + local_file_name)
        writefile_flag = true
      end

      if writefile_flag
        #Now, construct the file, 1st decode, 2nd, write it out
        attachment = File.new(RAILS_ROOT + "/public" + local_file_name, 'w+b')
        # Salesforce sends back an encoded data. It needs to be decoded into binary.
        # otherwise, it starts off with "/9j/4AAQSkZJRgABA......."
        decoded_data = Base64.decode64(filedata)
        attachment.write(decoded_data)     #=> 10
      end
  
      return local_file_name
    end

  end
end