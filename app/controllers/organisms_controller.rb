class OrganismsController < ApplicationController
  
  def top
  end

  def database_show
    @organisms = Organism.all
  end

  def create
    #@organisms = Organism.new(organisms_params)
  end

  def import
    Organism.import(params[:file])
    redirect_to organisms_url
  end
end
