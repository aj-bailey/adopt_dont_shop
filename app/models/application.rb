class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
  
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :description, presence: true

  enum status: ["In Progress", "Pending", "Accepted", "Rejected"]

  def pets_approved?
    self.pet_applications.where.not(status: "Approved").count == 0
  end

  def no_pets_in_progress?
    self.pet_applications.where(status: "In Progress").count == 0
  end
end