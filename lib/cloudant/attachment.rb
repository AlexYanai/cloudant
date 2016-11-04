module Cloudant
  module Attachment
    # The Attachment Module contains methods to interact with document attachments.
    #
    # Add an attachment to an existing document. 
    # Accepts the document id, the MIME type (ie: image/jpg), and the name for the attachment
    # a rev field is also required (and suggested), but if not, the document is searched and rev extracted
    def create_attachment(args)
      if args[:id]
        args[:rev] = get_current_rev(args[:id]) unless args[:rev]
        attachment = Cloudant::Attachment.make_attachment(args)
        query_str  = build_attachment_query(args)

        @conn.query({url_path: query_str, opts: attachment, method: :put})
      end
    end
    alias_method :update_attachment, :create_attachment

    # Read a document's attachments.
    # Accepts a document id and the name of an attachment associated with that doc.
    def read_attachment(args)
      query_str = build_attachment_query(args)
      
      @conn.query({url_path: query_str, method: :get})
    end

    # Delete a document's attachment.
    # Accepts a document id, the rev in question, and the name of an attachment associated with that doc.
    def delete_attachment(args)
      query_str = build_attachment_query(args)
      
      @conn.query({url_path: query_str, method: :delete})
    end

    # Accepts a Hash including :doc => the name of the doc to which the attachment will be attached,
    # file_name, the name to be given to the attachment, the doc's content type, and the attachment's
    # file type.
    # Returns attachment to be uploaded
    def self.make_attachment(args)
      doc_name  = args[:id]
      file_name = args[:name]
      file_type = args[:type]
      file_path = args[:path]

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
        raise Errno::ENOENT.new('file does not exist')
      end

      attachment
    end
  end
end