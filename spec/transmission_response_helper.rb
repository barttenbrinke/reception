class TransmissionResponseHelper
  
  def self.success
    Remote::Response.new('{"result": "success"}')
  end

  def self.successfull_torrent_add
    json_string = <<-JSON
      {
        "arguments": {
           "torrent-added":  
              { 
                  "name": "Fedora x86_64 DVD",
                  "id": 10,
                  "hashString": "ABCDEFHEAFUEFUEAHFALKFJ"
              }
           
        },
        "result": "success",
        "tag": 39693
      }
    JSON

    Remote::Response.new(json_string)
  end
  
  def self.failed_to_connect
    json_string = <<-JSON
      {
        "result": "failed_to_connect"
      }
    JSON

    return Remote::Response.new(json_string)
  end
  
  def self.empty
    Remote::Response.new("{}")
  end

  def self.broken
    Remote::Response.new("{/")
  end

end