class OrganismsController < ApplicationController
  @@tmp = String.new
  
  def top
  end

  def database_show
    @organisms = Organism.all.page(params[:page])
  end

  def create
    @acc = params[:acc]
    @@tmp = @acc
  end

  def download
    send_file "app/assets/images/#{@@tmp}.png" 
  end

  def import
    Organism.import(params[:file])
    redirect_to database_show_path
  end
end
