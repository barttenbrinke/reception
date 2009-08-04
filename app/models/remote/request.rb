class Remote::Request
  
  attr_accessor :data
  attr_accessor :method
  
  # Initialize Response using either a setting object or by finding one.
  # <tt>data</tt> Response object. Will be parsed using JSON.parse
  def initialize(request_method, request_data = {})
    self.data = request_data
    self.method = request_method
  end
  
  # Send the request
  # <tt>setting</tt> Optinal setting object, used to determine the transmission-daemon's location.
  def send(setting = Setting.find_or_create, session_id = @@TRANSMISSION_SESSION_ID, attempt = 1)
    begin
      http = Net::HTTP.new(setting.host, setting.port)
      http.open_timeout = 1
      http.read_timeout = 1
      
      # POST request -> logging in
      headers = {
        'Content-Type' => 'application/json',
        'Authorization' => 'Basic ' + setting.login,
        'X-Transmission-Session-Id' => session_id.to_s
      }

      json_packet = { :method => self.method, :arguments => self.data }.to_json
      resp, data = http.post(setting.path, json_packet, headers)
      
      if Object::DEBUG_RPC_MESSAGES
        y json_packet
        y resp
        y data
      end
      
      if resp.code.to_i == 409 && attempt < 2 && data
        session_id = data.match(/X-Transmission-Session-Id:\ (.*)<\/code>/)

        if session_id[1]
          @@TRANSMISSION_SESSION_ID = session_id[1]
          send(setting, session_id[1], attempt+1)
        end
      end
 
      return Remote::Response.new(data, resp)
    rescue Exception => err
      puts "Error: #{err.to_s} (#{err.class})"
    end
    
    error_string = <<-JSON
      {
        "result": "failed_to_connect"
      }
    JSON
    
    return Remote::Response.new(error_string)
  end
  
end