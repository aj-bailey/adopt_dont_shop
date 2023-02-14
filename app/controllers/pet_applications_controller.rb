class PetApplicationsController < ApplicationController
  def create
    pet_application = PetApplication.new(pet_application_params)
    if pet_application.save
      redirect_to "/applications/#{params[:application_id]}"
    else
      flash[:notice] = "Application not created: Required information missing."
      redirect_to  "/applications/#{params[:application_id]}"
    end
  end

  def update
    pet_application = PetApplication.find_by(application_id: params[:application_id], pet_id: params[:pet_id])
    
    pet_application.update(status: params[:status].to_i)
    
    application = Application.find(params[:application_id])
    
    if application.pets_approved?
      application.update(status: 2)
    elsif application.no_pets_in_progress?
      application.update(status: 3)
    end

    redirect_to "/admin/applications/#{params[:application_id]}"
  end

  private
  def pet_application_params
    params.permit(:pet_id, :application_id)
  end
end