class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :pet_applications
  has_many :applications, through: :pet_applications

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.search_by_name(name)
    self.where('name ILIKE ?', "%#{name}%")
  end

  def self.make_unadoptable
    self.all.each { |pet| pet.update(adoptable: false) }
  end

  def has_approved_application?
    self.applications.where(status: 2).count > 0
  end
end
