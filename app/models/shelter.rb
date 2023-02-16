class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def average_pet_age
    average_age = self.pets.average(:age)
    return "No Pets" unless average_age 
    average_age.round(1)
  end

  def adopted_pets_count
    self.pets.joins(:applications).where(applications: {status: 2}).count
  end

  def pending_pet_applications
    self.pets.joins(:applications).where(pet_applications: {status: 0})
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.order_by_reverse_alphabetical_names
    self.find_by_sql("SELECT * FROM shelters ORDER BY name DESC")
  end

  def self.pending_applications
    self.joins(pets: :applications).where(applications: {status: 1}).order(name: :asc).distinct
  end
  
  def self.name_and_address(id)
    shelter = self.find_by_sql("SELECT name, city FROM shelters WHERE id = #{id}").first
    {name: shelter.name, city: shelter.city}
  end
end
