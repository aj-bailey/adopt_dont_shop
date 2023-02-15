require 'rails_helper'

RSpec.describe 'Admin Shelters Show page' do 
  describe 'as a visitor' do
    describe 'when I visit an admin shelter show page' do
      before(:each) do 
        @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
        @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: false)
        @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
        visit "/admin/shelters/#{@shelter_1.id}"
      end 

      it 'will show the full name and address of that shelter' do 
        expect(page).to have_content(@shelter_1.name)
        expect(page).to have_content(@shelter_1.city)
      end
      
      it 'will show the average pet age for shelter in a section called statistics' do 
        within(".statistics") {
          expect(page).to have_content("Average Pet Age: 4.3")
        }
      end

      it 'will show count of pets that have been adopted in a section called statistics' do
        application = Application.create!(name: "Brian", street_address: "853 West Linden st", city: "Louisville", state: "colorado", zip_code: "80027", description: "I like animals", status: 2)
        application.pet_applications.create!(pet: @pet_1, status: 1)
        application.pet_applications.create!(pet: @pet_2, status: 1)

        visit "/admin/shelters/#{@shelter_1.id}"

        within(".statistics") {
          expect(page).to have_content("Count of Adopted Pets: 2")
        }
      end
    end
  end
end