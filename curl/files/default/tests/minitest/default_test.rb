describe_recipe "cookbook-curl" do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "package" do
    it "installs curl" do
      package("curl").must_be_installed
    end
  end
end
