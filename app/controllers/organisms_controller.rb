class OrganismsController < ApplicationController
  
  def top
  end

  def database_show
    @organisms = Organism.all
  end

  def create
    @acc = params[:acc]
  end

  def import
    Organism.import(params[:file])
    redirect_to organisms_url
  end
end
