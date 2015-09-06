class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    hash_of_ratios = {}
    all.each do |neighborhood|
      ratio = neighborhood.reservations.count / neighborhood.listings.count unless neighborhood.listings.count == 0
      hash_of_ratios[neighborhood] = ratio
    end
    hash_of_ratios.key(hash_of_ratios.values.compact.max)
  end

  def self.most_res
    most_res = 0
    neighborhood_with_most_res = nil
    all.each do |neighborhood|
      if neighborhood.reservations.count > most_res
        most_res = neighborhood.reservations.count
        neighborhood_with_most_res = neighborhood.id
      end
    end
    Neighborhood.find("#{neighborhood_with_most_res}")
  end

  def neighborhood_openings(first_date, second_date)
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
