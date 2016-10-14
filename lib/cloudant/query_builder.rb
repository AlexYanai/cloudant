module Cloudant
  module QueryBuilder
    class << self
      # TODO: Add a check to determine if options value is valid for key.
      # ex: {include_docs: true} is valid, {include_docs: 6} is not.
      def build(opts,type)
        query_str = ""
        fields    = get_fields(type)

        fields.each do |field|
          key = field
          val = opts[field].to_s

          current = "#{key}=#{val}"   if val != ""
          query_str << "&" << current if (query_str != "" && current)
          query_str << "?" << current if (query_str == "" && current)
        end

        query_str
      end

      # TODO: This will be expanded to calls other than /_view.
      def get_fields(type)
        if type == "view"
          return [:reduce,:include_docs,:descending,:endkey,:endkey_docid,:group,:group_level,:inclusive_end,:key,:keys,:limit,:skip,:stale,:startkey,:startkey_docid]
        elsif type == "all_docs"
          return [:include_docs,:descending,:endkey,:conflicts,:inclusive_end,:key,:limit,:skip,:startkey,:keys]
        elsif type == "changes"
          return [:include_docs,:descending,:feed,:filter,:heartbeat,:conflicts,:limit,:since,:style,:timeout,:doc_ids]
        end
      end
    end
  end
end