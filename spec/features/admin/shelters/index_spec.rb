require "rails_helper"

RSpec.describe "Admin Shelters Index Page" do
  describe "As a visitor" do
    before(:each) do 
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    end 

    describe "When I visit the admin shelter index '/admin/shelters'" do
      it 'can see all shelters in the system listed in reverse alphabetical order by name' do
        visit '/admin/shelters'
        
        expect('RGV animal shelter').to appear_before('Fancy pets of Colorado')
        expect('Fancy pets of Colorado').to appear_before('Aurora shelter')
      end

      it 'can see a "shelters with pending applications" section that lists every shelter with a pending application' do 
        application_1 = Application.create!(name: "Brian", street_address: "853 West Linden st", city: "Louisville", state: "colorado", zip_code: "80027", description: "I like animals", status: 1)
        application_2 = Application.create!(name: "Adam", street_address: "853 West Linden st", city: "Louisville", state: "colorado", zip_code: "80027", description: "I like animals more than my roomate", status: 1)
        application_3 = Application.create!(name: "John", street_address: "853 West Linden st", city: "Louisville", state: "colorado", zip_code: "80027", description: "I like animals", status: 3)
        jax = application_1.pets.create!(adoptable: false, age: 4, breed: "ACD", name: "Jax", shelter: @shelter_3)
        rylo = application_2.pets.create!(adoptable: false, age: 1, breed: "Lab", name: "Rylo", shelter: @shelter_1)
        frankie = application_3.pets.create!(adoptable: false, age: 1, breed: "Shih Tzu", name: "Frankie", shelter: @shelter_2)
       
        visit '/admin/shelters'

        within(".pending_applications") {
          expect(page).to have_content("Shelters with Pending Applications")
          expect("Aurora shelter").to appear_before("Fancy pets of Colorado")
        }
      end
    end
  end
end