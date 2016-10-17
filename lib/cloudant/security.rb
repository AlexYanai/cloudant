module Cloudant
  module Security
    # The Security Module contains methods to read and modify existing users,
    # permissions, and credentials. 
    # The default credentials provided upon account creaton have _admin level
    # access to all account databases; any subsequent users or API keys created
    # must have permissions explicitly set.
    #
    # View permissions for the current user
    # Can only be accessed after performing cookie auth
    def permissions
      @conn.query({url_path: "_session", method: :get})
    end

    # View existing user permissions in the database
    # Returns {"cloudant" => {"key" => ["_permission"]}}
    def roles
      @conn.query({url_path: "_api/v2/db/#{database}/_security", method: :get})
    end

    # Grant or revoke permissions
    # Accepts a document: {"cloudant" => {"key" => ["_permission"]}} 
    def update_roles(doc)
      @conn.query({url_path: "_api/v2/db/#{database}/_security", opts: doc, method: :put})
    end

    # Returns {"password" => "str", "key" => "str", "ok" => true}
    def create_api_keys
      @conn.query({url_path: "_api/v2/api_keys", method: :post})
    end

    # Methd to create and authorize a new set of credentials.
    # :new_user accepts and array of either symbols or hashes, corresponding to the roles
    # available in Cloudant as see in all_roles below.
    # Returns the credentials and roles {"password" => "str", "key" => "str", "ok" => true, "roles": []}
    def new_user(user_roles)
      checked = Security.check_roles(user_roles)

      if checked
        users = roles
        keys  = create_api_keys

        existing_users    = users["cloudant"]
        users["cloudant"] = {} unless existing_users # If no users exist a blank has is returned instead of {"cloudant": {}}

        users["cloudant"][keys["key"]] = checked
        keys["roles"] = checked
        
        update_roles(users)
      else
        raise ArgumentError.new('invalid - permitted roles: reader, writer, admin, replicator, db_updates, design, shards, security')
      end

      keys
    end
    
    # Accepts a string - a key with permissions already existing in the database
    # If the key isn't found within the database, no changes are made. 
    def delete_user(user)
      users    = roles
      existing = users["cloudant"]
      
      existing.delete(user) if existing
      update_roles(users)
    end

    # Checks input array to make sure it contains only valid roles.
    # Any invalid roles will be removed. If there are a mix of valid and invalid
    # roles in the array, the new user will be created with only the valid roles.
    # If the input is empty, or no valid roles are present, no user will be created.
    def self.check_roles(roles)
      all_roles = ["_reader","_writer","_admin","_replicator","_db_updates","_design","_shards","_security"]
      validated = []

      if roles && roles.is_a?(Array)
        roles.each do |role| 
          role_str = role.to_s
          role_str = role_str[1..-1] if role_str[0] == "_"
          role_str = "_#{role_str}" 

          validated <<  role_str if all_roles.include?(role_str)
        end
      end

      validated = nil if validated.empty?
      validated
    end
  end
end