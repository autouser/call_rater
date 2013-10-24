require 'spec_helper'

describe CallRater::Connection do
  
  before(:each) do
    @connection_config = test_config[:db]
  end

  context "#new" do
    it "accepts hash arguments" do
      expect{ CallRater::Connection.new(@connection_config) }.to_not raise_error
    end

    it "sets internal config" do
      con = CallRater::Connection.new(@connection_config)
      expect( con.config[:adapter] ).to_not be_nil
      expect( con.config[:database] ).to_not be_nil
    end
  end

  context "#connect", type: :ar do
    it "connects without database", type: :ar do
      expect{ con = CallRater::Connection.new(@connection_config).connect }.to_not raise_error
    end

    it "connects with database" do
      expect{ con = CallRater::Connection.new(@connection_config).connect(true) }.to_not raise_error
    end
  end

  context "#create_database and #drop_database" do
    it "raises no exception" do
      con = CallRater::Connection.new(@connection_config)
      con.drop_database
      con.create_database
    end
  end

end