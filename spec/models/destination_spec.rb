require 'spec_helper'

describe Destination do
  
  before(:each) {clean_db!}

  context "is valid" do
    it "with correct argumets" do
      expect( Destination.new(prefix: '21', name: 'Lausanne') ).to be_valid
    end
  end

  context "is invalid" do

    context "with empty" do
      it "name" do
        destination = Destination.new(prefix: '21')
        expect( destination ).to be_invalid
        expect( destination.errors.get(:name) ).to match_array(["can't be blank"])
      end

      it "prefix" do
        destination = Destination.new(name: 'Lausanne')
        expect( destination ).to be_invalid
        expect( destination.errors.get(:prefix) ).to match_array(["can't be blank"])
      end
    end

    context "with non unique" do
      before(:each) { @destination = Destination.create!(prefix: '21', name: 'Lausanne') }

      it "name" do
        destination = Destination.new(prefix: '22', name: 'Lausanne')
        expect( destination ).to be_invalid
        expect( destination.errors.get(:name) ).to match_array(["has already been taken"])
      end

      it "prefix" do
        destination = Destination.new(prefix: '21', name: 'Geneva')
        expect( destination ).to be_invalid
        expect( destination.errors.get(:prefix) ).to match_array(["has already been taken"])
      end

    end

  end

  context "#price_per_second", focus: true do
    it "is calculated" do
      destination = Destination.new(prefix: '21', name: 'Geneva', price_per_minute: 120)
      expect( destination.price_per_second ).to eq(2)
    end
  end

end