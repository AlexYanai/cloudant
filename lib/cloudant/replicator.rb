module Cloudant
  module Replicator
    # The Replicator Module contains methods to replicate a database
    #
    # Allows you to monitor a replication 
    def active_tasks(type="replication")
      @conn.query({url_path: "_active_tasks", opts: {"type" => type}, method: :get})
    end

    def replicate_db(target,*opts)
      opts && opts[0] ? options = opts[0] : options = {}

      options[:target] = target
      replication_doc  = build_doc(options)
      doc_name = Cloudant::Utility.generate_doc_name(database,target)
      @conn.query({url_path: "_replicator/#{doc_name}", opts: replication_doc, method: :put})
    end

    def sync(target)
      replicate_db(target,{:continuous => true, :create_target => true})
    end

    def build_doc(opts)
      fields = [:continuous,:create_target,:doc_ids,:filter,:proxy,:selector,:since_seq,:use_checkpoints,:user_ctx]

      replication_doc = {
        :source => "https://#{username}:#{password}@#{username}.cloudant.com/#{database}",
        :target => "https://#{username}:#{password}@#{username}.cloudant.com/#{opts[:target]}",
        :create_target => true,
        :continuous => false
      }  

      fields.each do |field|
        current = field.to_sym
        replication_doc[current] = opts[current] if !opts[current].nil?
      end    

      replication_doc
    end
  end
end