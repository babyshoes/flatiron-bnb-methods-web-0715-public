class City < ActiveRecord::Base

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings


  def self.highest_ratio_res_to_listings
    hash_of_ratios = {}
    all.each do |city|
      ratio = city.reservations.count / city.listings.count unless city.listings.count == 0
      hash_of_ratios[city] = ratio
    end
    hash_of_ratios.key(hash_of_ratios.values.compact.max)
  end

  def self.most_res
    most_res = 0
    city_with_most_res = nil
    all.each do |city|
      if city.reservations.count > most_res
        most_res = city.reservations.count
        city_with_most_res = city.id
      end
    end
    City.find("#{city_with_most_res}")
  end

  def city_openings(first_date, second_date)
    beginning_of_range = Date.parse(first_date)
    end_of_range = Date.parse(second_date)
    listings.select do |listing|
      listing.reservations.select do |reservation|
        reservation.checkin > beginning_of_range ||
        reservation.checkout < end_of_range ||
        reservation.checkin < beginning_of_range && reservation.checkout > end_of_range
      end
    end
  end

end
