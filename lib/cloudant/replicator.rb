module Cloudant
  module Replicator
    # The Replicator Module contains methods to replicate a database
    #
    # Allows you to monitor a replication 
    def active_tasks(type="replication")
      @conn.query({url_path: "_active_tasks", opts: {"type" => type}, method: :get})
    end

    def replicate_db(target,*opts)
      continuous = false
      continuous = true if opts && opts[0] && opts[0][:sync]
      doc = {
        "source": "https://#{username}:#{password}@#{username}.cloudant.com/#{database}",
        "target": "https://#{username}:#{password}@#{username}.cloudant.com/#{target}",
        "create_target": true,
        "continuous": continuous
      }
      doc_name = Cloudant::Utility.generate_doc_name(database,target)

      @conn.query({url_path: "_replicator/#{doc_name}", opts: doc, method: :put})
    end
  end
end