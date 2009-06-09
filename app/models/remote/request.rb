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
  def send(setting = Setting.find_or_create)
    begin
      http = Net::HTTP.new(setting.host, setting.port)
      http.open_timeout = 1
      http.read_timeout = 1
      
      # POST request -> logging in
      headers = {
        'Content-Type' => 'application/json',
        'Authorization' => 'Basic ' + setting.login
      }

      json_packet = { :method => self.method, :arguments => self.data }.to_json
      
      y json_packet if Object::DEBUG_RPC_MESSAGES == true
      
      resp, data = http.post(setting.path, json_packet, headers)

      return Remote::Response.new(data)
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