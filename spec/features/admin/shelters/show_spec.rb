require 'rails_helper'

RSpec.describe 'Admin Shelters Show page' do 
  describe 'as a visitor' do
    describe 'when I visit an admin shelter show page' do
      it 'will show the full name and address of that shelter' do 
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

      visit "/admin/shelters/#{@shelter_1.id}"
      
      expect(page).to have_content(@shelter_1.name)
      expect(page).to have_content(@shelter_1.city)
      end
    end
  end
end