require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:applications).through(:pet_applications) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end

    describe '::search_by_name' do 
      it 'returns all pets with a case insensitive partial name' do 
        expect(Pet.search_by_name('mr.')).to eq([@pet_1])
      end
    end

    describe '::make_unadoptable' do 
      it 'changes all pets adoptable status to false' do 
        Pet.make_unadoptable
        
        expect(Pet.find(@pet_1.id).adoptable).to eq(false)
        expect(Pet.find(@pet_2.id).adoptable).to eq(false)
        expect(Pet.find(@pet_3.id).adoptable).to eq(false)
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '#has_approved_application?' do
      it 'returns true if the pet has an approved application' do
        application = Application.create!(name: "Brian", street_address: "853 West Linden st", city: "Louisville", state: "colorado", zip_code: "80027", description: "I like animals", status: 2)
        application.pet_applications.create!(pet: @pet_3, status: 1)

        expect(@pet_3.has_approved_application?).to eq(true)
      end
    end
  end
end
