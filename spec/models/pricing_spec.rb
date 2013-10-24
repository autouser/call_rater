require 'spec_helper'

describe Pricing do
  
  before(:each) do
    clean_db!

    @call = Call.create!(timestamp: '2013-10-23 00:00:01', caller: '22222222', callee: '21333333', duration: 10)
    @destination = Destination.new(prefix: '21', name: 'Lausanne', price_per_minute: 120)

  end

  context "is valid" do
    it "with correct argumets" do
      expect( Pricing.new(call: @call, destination: @destination) ).to be_valid
    end
  end

  context "is invalid" do
    context "with empty" do
      it "call" do
        pricing =  Pricing.new(destination: @destination)
        expect( pricing ).to be_invalid
        expect( pricing.errors.get(:call) ).to match_array(["can't be blank"])
      end

      it "destination" do
        pricing =  Pricing.new(call: @call)
        expect( pricing ).to be_invalid
        expect( pricing.errors.get(:destination) ).to match_array(["can't be blank"])
      end
    end
  end

  context "before save" do
    it "calculates amount" do
      pricing = Pricing.create!(call: @call, destination: @destination)
      expect( pricing.amount ).to eq(20)
    end
  end

end