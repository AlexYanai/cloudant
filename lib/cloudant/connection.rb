module Cloudant
  class Connection
    attr_accessor :cookies
    attr_reader   :username, :password, :base_uri

    def initialize(args)
      @username = args[:username]
      @password = args[:password]
      @base_uri = args[:base_uri]
    end

    def query(args)
      base         = URI.parse("#{base_uri}#{args[:url_path]}")
      http         = Net::HTTP.new(base.host, 443)
      http.use_ssl = true
      request      = new_net_http_crud(args[:method],base)
      
      opts = args[:opts] ? args[:opts] : { "Cookie" => cookies }

      request.body            = JSON.generate(opts)
      request['Cookie']       = cookies
      request["Content-Type"] = "application/json"
      response                = http.request(request)

      JSON.parse(response.body)    
    end

    def cookie_auth
      response = start_session
      @cookies = get_cookies(response)
    end

    def close
      query({url_path: "_session", method: :delete})
    end

    private
    def new_net_http_crud(method,base)
      method = method.to_sym.capitalize
      Net::HTTP.const_get(method).new(base.request_uri)
    end
    
    def start_session
      RestClient.post("#{base_uri}_session", session_params)
    end

    def get_cookies(response)
      headers = response.headers
      cookies = headers[:set_cookie] if headers && headers.is_a?(Hash)
      cookies.is_a?(Array) ? cookie = cookies.first : cookie = cookies
      cookie
    end

    def session_params
      {
        username: username, 
        password: password, 
        "Content-Type" => "application/x-www-form-urlencoded", 
        "Accept" => "*/*"
      }
    end
  end
end
