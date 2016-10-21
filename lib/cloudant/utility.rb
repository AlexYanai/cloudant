module Cloudant
  module Utility
    def self.generate_doc_name(source,target)
      time_now = Time.now.strftime('%F-%T').gsub(/(:|-)/,"_")
      "#{source}_to_#{target}_#{time_now}"
    end
  end
end