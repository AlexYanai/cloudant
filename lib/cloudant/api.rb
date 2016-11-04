module Cloudant
  module API
    include Cloudant::Utility
    include Cloudant::QueryBuilder
    include Cloudant::Security
    include Cloudant::Replicator
    include Cloudant::Attachment
  end
end