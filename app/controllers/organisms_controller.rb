class OrganismsController < ApplicationController
  def index
    @organisms = Organism.all
  end

  def import
    Organism.import(params[:file])
    redirect_to organisms_url
  end
end
