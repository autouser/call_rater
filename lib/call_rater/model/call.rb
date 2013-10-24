class Call < ActiveRecord::Base

  has_one :pricing

  validates_presence_of :caller, :callee, :timestamp

  validate :check_caller

  def find_best_destination
    d = Destination.joins("RIGHT JOIN calls ON (calls.callee LIKE concat(destinations.prefix, '%') AND calls.id = #{id} )").order('length(destinations.prefix) DESC').first
    d.id.nil? ? nil : d
  end

  def create_pricing
    p = Pricing.find_or_initialize_by(call_id: id)
    p.destination = find_best_destination
    p.save ? p : nil
  end

  def self.process
    chain = self.joins("LEFT JOIN pricings ON (pricings.call_id = calls.id)").where("pricings.id is null")
    chain.each do |call|
      call.create_pricing
    end
  end

  private

  def check_caller
    errors.add(:caller, "can't be equal to callee") if callee == caller
  end

end