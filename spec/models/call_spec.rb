require 'spec_helper'

describe Call do
  
  before(:each) {clean_db!}

  context "is valid" do
    it "with correct argumets" do
      expect( Call.new(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '22333333') ).to be_valid
    end
  end

  context "is invalid" do
    it "with empty timestamp" do
      call = Call.new(caller: '22222222', callee: '22333333')
      expect( call ).to be_invalid
      expect( call.errors.get(:timestamp) ).to match_array(["can't be blank"])
    end
    it "with empty caller" do
      call = Call.new(timestamp: '2013-10-23 00:00:01', callee: '22333333')
      expect( call ).to be_invalid
      expect( call.errors.get(:caller) ).to match_array(["can't be blank"])
    end
    it "with empty callee" do
      call = Call.new(timestamp: '2013-10-23 00:00:01', caller: '22222222')
      expect( call ).to be_invalid
      expect( call.errors.get(:callee) ).to match_array(["can't be blank"])
    end

    it "with caller equal to callee" do
      call = Call.new(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '22222222')
      expect( call ).to be_invalid
      expect( call.errors.get(:caller) ).to match_array(["can't be equal to callee"])
    end

  end

  context "#find_best_destination" do
    
    before(:each) do
      not_matching_destination = Destination.create! prefix: '66',   name: 'Not Matching Destination', price_per_minute: 120
    end

    it "with one destination matched" do
      short_destination = Destination.create! prefix: '41',   name: 'Short Destination', price_per_minute: 120
      call = Call.create!(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '41222222')
      expect( call.find_best_destination ).to eq(short_destination)
    end

    it "with two destinations matched" do
      short_destination = Destination.create! prefix: '41', name: 'Short Destination', price_per_minute: 120
      long_destination = Destination.create! prefix: '4122', name: 'Long Destination', price_per_minute: 120
      call = Call.create!(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '41222222')
      expect( call.find_best_destination ).to eq(long_destination)
    end

    it "with no destination matched" do
      call = Call.create!(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '41222222')
      expect( call.find_best_destination ).to be_nil
    end

  end

  context "#create_pricing" do
    it "with two destinations matched" do
      short_destination = Destination.create! prefix: '41', name: 'Short Destination', price_per_minute: 120
      long_destination = Destination.create! prefix: '4122', name: 'Long Destination', price_per_minute: 240
      call = Call.create!(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '41222222', duration: 10)
      pricing = call.create_pricing
      expect( pricing.call ).to eq(call)
      expect( pricing.destination ).to eq(long_destination)
      expect( pricing.amount ).to eq(40)
    end

    it "with no destination matched" do
      call = Call.create!(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '41222222')
      expect( call.create_pricing ).to be_nil
    end

  end

end