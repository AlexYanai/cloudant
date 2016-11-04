module Cloudant
  module Attachment
    # The Attachment Module contains methods to interact with document attachments.

    # Accepts a Hash including :doc => the name of the doc to which the attachment will be attached,
    # file_name, the name to be given to the attachment, the doc's content type, and the attachment's
    # file type.
    # Returns attachment to be uploaded
    def self.create_attachment(args)
      doc_name   = args[:doc]
      file_name  = args[:name]
      file_type  = args[:type]
      file_path  = args[:path]
      attachment = {
        "_id" => doc_name,
        "_attachments" => {
          file_name => {
            "content_type" => file_type
          }
        }
      }

      if File.exists?(file_path)
        data = File.open(file_path,'rb').read
        attachment["_attachments"][file_name]["data"] = data
      else
        raise ArgumentError.new('file does not exist')
      end

      attachment
    end
  end
end