class Setting < ActiveRecord::Base
  
  def self.find_or_create
    setting = Setting.find(:first)
    
    if setting.nil?
      setting = Setting.new(:host => 'localhost', :port => '9091', :path => '/transmission/rpc', :ratio => 2.00, :session_uplimit => 10, :session_downlimit => 512)
      setting.save!
    end
    
    return setting
  end
  
  def login
    Base64.encode64("#{user}:#{password}").chop
  end
  
end
