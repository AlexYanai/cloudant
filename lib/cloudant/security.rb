module Cloudant
  module Security
    # View permissions for the current user
    # Can only be accessed after performing cookie auth
    def permissions
      @conn.query({url_path: "_session", method: :get})
    end

    # Returns {"password" => "str", "key" => "str", "ok" => true}
    def create_api_keys
      @conn.query({url_path: "_api/v2/api_keys", method: :post})
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

    def new_user(user_roles)
      users   = roles
      keys    = create_api_keys
      checked = Security.check_roles(user_roles)

      if checked
        existing_users    = users["cloudant"]
        users["cloudant"] = {} unless existing_users # If no users exist a blank has is returned instead of {"cloudant": {}}

        users["cloudant"][keys["key"]] = checked
        keys["roles"] = checked
      end

      update_roles(users)
      keys
    end

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