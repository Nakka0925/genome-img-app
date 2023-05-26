class OrganismsController < ApplicationController
  @@tmp = String.new
  
  def top
  end

  def database_show
    if params[:search].present?
      @organisms = Organism.where("classes like ?", "%#{params[:search]}%").page(params[:page])
    else
      @organisms = Organism.all.page(params[:page])
    end
  end

  def create
    @acc = params[:acc]
    @@tmp = @acc
  end

  def download
    send_file "app/assets/images/#{@@tmp}.png" 
  end

  def predict
    @acc = params[:acc]
    @entry = Genome.new()
  end

  def import
    Organism.import(params[:file])
    redirect_to database_show_path
  end
end
