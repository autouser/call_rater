class Destination < ActiveRecord::Base

  validates_presence_of :name, :prefix
  validates_uniqueness_of :name
  validates_uniqueness_of :prefix

  def price_per_second
    price_per_minute / 60
  end

end