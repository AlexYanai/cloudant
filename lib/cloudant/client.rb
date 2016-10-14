module Cloudant
  class Client
    attr_reader   :username, :password
    attr_accessor :database, :base_uri

    def initialize(args)
      @username = args[:username]
      @password = args[:password]
      @database = args[:database]
      @base_uri = "https://#{username}.cloudant.com/"
      @conn     = start_connection(username,password,base_uri)

      @conn.cookie_auth
    end

    # Retrieve all docs from the database
    def all_docs(*opts)
      q = "#{database}/_all_docs"
      q << QueryBuilder.build(opts.first,"all_docs") if opts && opts.any? && opts.first.is_a?(Hash)

      @conn.query({url_path: q, method: :get})
    end

    # Accepts a single document id and returns it if found
    def get_doc(id)
      @conn.query({url_path: "#{database}/#{id}", method: :get})
    end
    alias_method :get, :get_doc
    alias_method :doc, :get_doc

    # A valid doc must be provided. The doc must be a hash that can.
    # Use create_docs to create multiple documents at once.
    def create_doc(doc)
      @conn.query({url_path: "#{database}", opts: doc, method: :post})
    end
    alias_method :create, :create_doc
    alias_method :post,   :create_doc

    # Returns an error hash if a valid id isn't given
    def update_doc(doc)
      id = doc["_id"] if doc["_id"]

      @conn.query({url_path: "#{database}/#{id}", opts: doc, method: :put})
    end
    alias_method :put, :update_doc

    # Intended behavior for this method to accept only an id to delete a doc.
    # TODO: Add an optional param for rev.
    def delete_doc(id)
      doc = get_doc(id)
      rev = doc["_rev"] if doc["_rev"]

      @conn.query({url_path: "#{database}/#{id}?rev=#{rev}", method: :delete})
    end
    alias_method :delete, :delete_doc

    # Convenience method: this is functionally equivalent to get_doc if
    # "/_design" is prepended to the id. 
    # ie: get_doc("/_design/:id") == get_design_doc(":id")
    def get_design_doc(id)
      @conn.query({url_path: "#{database}/_design/#{id}", method: :get})
    end
    alias_method :ddoc, :get_design_doc

    # Need to provide valid design doc or returns an error hash.
    def create_design_doc(id,doc)
      @conn.query({url_path: "#{database}/_design/#{id}", opts: doc, method: :put})
    end
    alias_method :update_design_doc, :create_design_doc
    alias_method :create_ddoc,       :create_design_doc

    # Intended behavior for this method to accept only an id to delete a doc.
    # TODO: Add an optional param for rev.
    def delete_design_doc(id)
      doc = get_design_doc(id)
      rev = doc["_rev"] if doc && doc["_rev"]

      @conn.query({url_path: "#{database}/_design/#{id}?rev=#{rev}", opts: doc, method: :delete})
    end

    # Id of the design doc in which the view (doc) will be held.
    # Views must be held in design docs; if no design doc matches the id
    # provided, one will be created with said id.
    def create_view(id,doc)
      resp = get_design_doc(id)
      ddoc = set_views(resp,doc)

      create_design_doc(id,ddoc)
    end

    # Get a hash {"results" => []}, containing a hash of seq, id, changes
    def changes(*opts)
      q = "#{database}/_changes"
      q << QueryBuilder.build(opts.first,"changes") if opts && opts.any? && opts.first.is_a?(Hash)

      @conn.query({url_path: q, method: :get})
    end

    # Returns all database for the current instance of Cloudant
    def all_dbs
      @conn.query({url_path: "_all_dbs", method: :get})
    end

    # Returns info about the database, including update_seq, db_name etc.
    def db_info
      @conn.query({url_path: "#{database}", method: :get})
    end
    alias_method :info, :db_info

    # Create  a new database for the current Cloudant instance
    def create_db(database)
      @conn.query({url_path: database, method: :put})
    end

    def delete_db(database)
      @conn.query({url_path: database, method: :delete})
    end

    # Create a new index. A valid index must be given.
    # Note: An index will be created if only a name is provided (see below)
    def create_index(args)
      if args[:name]
        new_index = create_new_index(args)

        @conn.query({url_path: "#{database}/_index", opts: new_index, method: :post})
      else
        raise ArgumentError.new('name is required')
      end
    end

    # If only a name is provided the default index doc is {"type": "text","index": {}}
    # The default index, {}, will index all fields in all docs. This may take a long
    # time with large databases.
    def create_new_index(args)
      new_index = {}
      
      args[:index] ? new_index["index"] = args[:index] : new_index["index"] = {}
      
      new_index["name"]  = args[:name] if args[:name]
      new_index["ddoc"]  = args[:ddoc] if args[:ddoc]

      args[:type] ? new_index["type"] = args[:type] : new_index["type"] = "text"

      new_index
    end

    # Returns all in order of creation
    def get_indices
      @conn.query({url_path: "#{database}/_index", method: :get})
    end
    alias_method :get_indexes, :get_indices

    # Delete an index
    def delete_index(args)
      @conn.query({url_path: "#{database}/_index/#{args[:ddoc]}/#{args[:type]}/#{args[:name]}", method: :delete})
    end

    # Use an existing view. Accepts an options hash containing valid args for a query string.
    # If no options are given the returned value will be the value of the view's reduce function,
    # if it has one, or rows containing keys, ids, and values if not.
    def view(ddoc,view,*opts)
      q  = "#{database}/_design/#{ddoc}/_view/#{view}"
      q << QueryBuilder.build(opts.first,"view") if opts && opts.any? && opts.first.is_a?(Hash)

      @conn.query({url_path: q, method: :get})
    end

    # Accepts an array of docs. Ids and revs are optional for creation but required for update.
    def create_docs(docs_array)
      bulk_docs(docs_array)
    end
    alias_method :update_docs, :create_docs

    # Requires the original doc including id and rev fields.
    # Accepts and array of docs. Unlike :delete_doc, this doesn't make
    # a request to get the docs beforehand and won't accept just ids.
    def delete_docs(docs_array)
      docs_array.each { |doc| doc["_deleted"] = true }
      bulk_docs(docs_array)
    end

    # Query the database. Returns all found results at once.
    # TODO: Expand query functionality.
    def query(q)
      @conn.query({url_path: "#{database}/_find", opts: q, method: :post})
    end

    # Paginate query results - best for large volume.
    # TODO: add feature that allows users to view previous pages and generall move into own class.
    def bookmark_query(q,&blk)
      response = query(q)
      bookmark = response["bookmark"]
      docs     = response["docs"]

      until !docs || docs.empty?
        yield docs
        q["bookmark"] = bookmark
        response      = query(q)
        bookmark      = response["bookmark"]
        docs          = response["docs"]
      end

      docs
    end

    # Delete the current cookie.
    def close
      @conn.close
    end

    private
    def start_connection(username,password,base_uri)
      Connection.new({username: username, password: password, base_uri: base_uri})
    end

    def bulk_docs(docs)
      opts = { "docs" => docs }
      @conn.query({url_path: "#{database}/_bulk_docs", opts: opts, method: :post})
    end

    def set_views(response,doc)
      response["views"] = {} unless response["views"]
      response["views"] = response["views"].merge(doc)
      response
    end
  end
end