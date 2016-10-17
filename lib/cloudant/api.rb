module Cloudant
  module API
    include Cloudant::QueryBuilder
    include Cloudant::Security
  end
end