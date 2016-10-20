module Cloudant
  module Replicator
    # The Replicator Module contains methods to replicate a database
    # 
    def active_tasks
      @conn.query({url_path: "_active_tasks", method: :get})
    end
  end
end