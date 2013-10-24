class Pricing < ActiveRecord::Base

  belongs_to :call
  belongs_to :destination

  validates_presence_of :call
  validates_presence_of :destination

  before_save :calculate_amount


  private

  def calculate_amount
    if call && destination
      self.amount = call.duration * destination.price_per_second
    end
  end

end