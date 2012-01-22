require "spec_helper"

describe TestPilot::Auth do
  before do
    @cli = TestPilot::Auth
    @cli.stub!(:check)
    @cli.stub!(:display)
    @cli.stub!(:running_on_a_mac?).and_return(false)
    @cli.stub!(:set_credentials_permissions)
    @cli.credentials = nil

    FakeFS.activate!

    FileUtils.mkdir_p(File.dirname(@cli.credentials_file))
    File.open(@cli.credentials_file, "w") do |file|
      file.puts "user\npass"
    end
  end

  after do
    FakeFS.deactivate!
  end

  it "reads credentials from the credentials file" do
    @cli.read_credentials.should == %w(user pass)
  end

  it "takes the user from the first line and the password from the second line" do
    @cli.read_credentials
    @cli.user.should == 'user'
    @cli.password.should == 'pass'
  end


end
