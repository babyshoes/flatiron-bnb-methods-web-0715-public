class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validate :associated_neighborhood_exists
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  after_create :set_host_status
  after_destroy :set_host_status_to_false_if_all_destroyed

  def associated_neighborhood_exists
    errors.add(:neighborhood, "can't be blank") if neighborhood == nil
  end

  def set_host_status
    host.host = true
    host.save
  end

  def set_host_status_to_false_if_all_destroyed
    host.host = false if self.host.listings.empty?
    host.save
  end

  def average_review_rating
    sum = self.reviews.inject(0) {|sum, review| sum + review.rating}
    sum.round(2) / self.reviews.count
  end

end
