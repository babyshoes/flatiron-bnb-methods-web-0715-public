class Reservation < ActiveRecord::Base
  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :reservation_not_on_own_listing
  validate :listing_is_available
  validate :checkin_is_before_checkout, :checkin_different_from_checkout
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  def reservation_not_on_own_listing
    errors.add(:reservation, "cannot reserve own listing") if listing.host == guest
  end

  def listing_is_available
    if checkin && checkout
      listing.reservations.each do |reservation|
        this_trip = checkin..checkout
        other_trip = reservation.checkin..reservation.checkout
        if ([*this_trip] & [*other_trip]).any?
          errors.add(:reservation, "listing not available")
        end
      end
    end
  end

  def checkin_is_before_checkout
    if checkin && checkout
      errors.add(:reservation, "checkin must be before checkout") unless checkin < checkout
    end
  end

  def checkin_different_from_checkout
    if checkin && checkout
      errors.add(:reservation, "checkin must be before checkout") unless checkin = checkout
    end
  end

  def duration
    (checkin...checkout).count
  end

  def total_price
    listing.price.to_f * duration
  end



end
