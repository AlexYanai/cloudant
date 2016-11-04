module Cloudant
  module API
    include Cloudant::Utility
    include Cloudant::QueryBuilder
    include Cloudant::Attachment
    include Cloudant::Security
    include Cloudant::Replicator
  end
end