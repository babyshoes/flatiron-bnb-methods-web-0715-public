class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, class_name: "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_exists

  def reservation_exists
    errors.add(:review, "reservation does not exist") unless reservation &&
    reservation.status == "accepted" &&
    reservation.checkout < Date.today
  end

end
