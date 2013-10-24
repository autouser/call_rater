require "spec_helper"

describe "Pricing" do
  before(:each) {clean_db!}

  describe "is calculated" do

    before(:each) do
      @destinations = []
      [
        {prefix: '21',   name: 'Lausanne',            price_per_minute: 120},
        {prefix: '22',   name: 'Geneva',              price_per_minute: 240},
        {prefix: '24',   name: 'Yverdon',             price_per_minute: 120},
        {prefix: '26',   name: 'Fribourg',            price_per_minute: 120},
        {prefix: '27',   name: 'Sion',                price_per_minute: 120},
        {prefix: '31',   name: 'Bern',                price_per_minute: 120},
        {prefix: '32',   name: 'Biel',                price_per_minute: 120},
        {prefix: '33',   name: 'Berner',              price_per_minute: 120},
        {prefix: '34',   name: 'Region Bern-Emme',    price_per_minute: 120},
        {prefix: '41',   name: 'Central Switzerland', price_per_minute: 120},
        {prefix: '4122', name: 'Long Prefix',         price_per_minute: 240},
      ].each {|d| @destinations << Destination.create!(d) }
    end

    it "with two not rated calls" do
      @ready = Call.create! timestamp: '2013-10-24 00:00:01', caller: '21333333', callee: '22333333', duration: 5  
      @ready.create_pricing
      calls = []
      [
        {timestamp: '2013-10-24 00:00:01', caller: '21333333', callee: '24333333', duration: 5},
        {timestamp: '2013-10-24 00:00:11', caller: '21333333', callee: '41223333', duration: 5}
      ].each {|c| calls << Call.create!(c) }
      Call.process
      expect( Pricing.count ).to eq(3)
      expect( Pricing.find_by(call_id: calls[0].id).amount ).to eq(10)
      expect( Pricing.find_by(call_id: calls[1].id).amount ).to eq(20)
    end

    it "with one not rated call and one w/o destination" do
      @ready = Call.create! timestamp: '2013-10-24 00:00:01', caller: '21333333', callee: '22333333', duration: 5  
      @ready.create_pricing
      calls = []
      [
        {timestamp: '2013-10-24 00:00:01', caller: '21333333', callee: '24333333', duration: 5},
        {timestamp: '2013-10-24 00:00:11', caller: '21333333', callee: '66223333', duration: 5}
      ].each {|c| calls << Call.create!(c) }
      Call.process
      expect( Pricing.count ).to eq(2)
      expect( Pricing.find_by(call_id: calls[0].id).amount ).to eq(10)
    end

    it "with 100 calls" do

      callers = %w(
        21111111 22111111 23111111 24111111 25111111
      )
      start_time = DateTime.parse('2013-10-01 00:00:00').to_time
      callers.each do |caller|
        (1..10).each do |n|
          current_time = start_time + 10*n
        
          @destinations[0, 2].each do |destination|
            callee = destination.prefix + '555555'
            Call.create! timestamp: current_time, caller: caller, callee: callee, duration: 10
          end
        end
      end

      Call.process

      expect( Pricing.where(destination_id: @destinations[0].id).sum(:amount) ).to eq(1000)
      expect( Pricing.where(destination_id: @destinations[1].id).sum(:amount) ).to eq(2000)

    end


  end

end