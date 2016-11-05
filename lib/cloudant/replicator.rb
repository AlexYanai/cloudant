module Cloudant
  module Replicator
    # The Replicator Module contains methods to replicate a database.
    # The module assumes that the database to be replicated is the database currently
    # set in the client; replicating another database requires a new database to be
    # set beforehand or use of :replicate_dbs.
    #
    # Allows you to monitor a replication 
    def active_tasks(type="replication")
      @conn.query({url_path: "_active_tasks", opts: {"type" => type}, method: :get})
    end

    # Accepts a string, the name of a database towards which to replicate the database. and 
    # optionally a hash of options for creating the replication doc.
    def replicate_db(target,*opts)
      opts && opts[0] ? options = opts[0] : options = {}
      options[:source] = database
      options[:target] = target
      
      replication(options)
    end

    # Allows database replication between 2 databses instead of defaulting to the set database.
    def replicate_dbs(source,target,*opts)
      opts && opts[0] ? options = opts[0] : options = {}
      options[:source] = source
      options[:target] = target
      
      replication(options)
    end

    # Sets the database to repliacte the 2 databases continuously.
    def sync(target)
      replicate_db(target,{:continuous => true, :create_target => true})
    end

    # Method accepts options for replication document and builds query
    def replication(args)
      replication_doc = build_doc(args)

      doc_name = Cloudant::Utility.generate_doc_name(args[:source],args[:target])
      @conn.query({url_path: "_replicator/#{doc_name}", opts: replication_doc, method: :put})
    end

    # The default options assume that the target database does not exist and the replication
    # will be one-time only.
    def build_doc(opts)
      fields = [:continuous,:create_target,:doc_ids,:filter,:proxy,:selector,:since_seq,:use_checkpoints,:user_ctx]

      replication_doc = {
        :source        => "https://#{username}:#{password}@#{username}.cloudant.com/#{opts[:source]}",
        :target        => "https://#{username}:#{password}@#{username}.cloudant.com/#{opts[:target]}",
        :create_target => true,
        :continuous    => false
      }  

      fields.each do |field|
        current = field.to_sym
        replication_doc[current] = opts[current] if !opts[current].nil?
      end    

      replication_doc
    end
  end
end