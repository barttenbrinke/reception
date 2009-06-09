require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Setting do
  before(:each) do
    @setting = Setting.find_or_create
  end

  it "should be valid" do
    @setting.should be_valid
  end
  
  it "should generate a login" do
    @setting.user     = "trans"
    @setting.password = "mission"
    @setting.login.should eql("dHJhbnM6bWlzc2lvbg==")
  end
end
