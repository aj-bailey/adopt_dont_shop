class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_reverse_alphabetical_names
    @shelters_with_pending_applications =Shelter.pending_applications
  end

  def show
    @shelter_name_and_address = Shelter.name_and_address(params[:id])
    @shelter = Shelter.find(params[:id])
  end
end