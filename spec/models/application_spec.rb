require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:pet_applications) }
    it { should have_many(:pets).through(:pet_applications) }
  end

  describe 'validations' do 
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:description) }
  end

  describe '#instance methods' do
    describe '#pets_approved?' do
      it 'returns true if all pet_applications associated with application are approved' do
        @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        @application_1 = Application.create!(name: "Brian", street_address: "853 West Linden st", city: "Louisville", state: "colorado", zip_code: "80027", description: "I like animals", status: 1)
        @jax = Pet.create!(adoptable: true, age: 1, breed: "ACD", name: "Jax", shelter: @shelter_1)
        @rylo = Pet.create!(adoptable: true, age: 1, breed: "Lab", name: "Rylo", shelter: @shelter_1)
        @application_1.pet_applications.create!(pet: @jax, status: 1)
        @application_1.pet_applications.create!(pet: @rylo, status: 1)

        expect(@application_1.pets_approved?).to eq(true)
      end
    end

    describe '#no_pets_in_progress?' do
      it 'returns true if all pet_applications associated with application are not pending' do
        @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        @application_1 = Application.create!(name: "Brian", street_address: "853 West Linden st", city: "Louisville", state: "colorado", zip_code: "80027", description: "I like animals", status: 1)
        @jax = Pet.create!(adoptable: true, age: 1, breed: "ACD", name: "Jax", shelter: @shelter_1)
        @rylo = Pet.create!(adoptable: true, age: 1, breed: "Lab", name: "Rylo", shelter: @shelter_1)
        @application_1.pet_applications.create!(pet: @jax, status: 1)
        @application_1.pet_applications.create!(pet: @rylo, status: 2)

        expect(@application_1.no_pets_in_progress?).to eq(true)
      end
    end
  end
end