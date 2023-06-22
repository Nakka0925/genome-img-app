class OrganismsController < ApplicationController
  
  def top
  end

  def database_show
    if params[:search].present? # TODO: 条件の絞り込みで検索をおこなう
      @organisms = Organism.where("classes like ?", "%#{params[:search]}%").page(params[:page])
    else
      @organisms = Organism.all.page(params[:page])
    end
  end

  def create
    if Organism.where(replicon: params[:acc]).present? #データベースに存在するかチェック
      @page_title = params[:acc]
      flash[:acc] = params[:acc]
    else 
      flash.now[:alert] = 'データベースに登録されていない生物です'
      render :top
    end
  end

  def download
    send_file "app/assets/images/#{flash[:acc]}.png" 
  end

  def predict
    @page_title = params[:acc]
    @entry = Genome.new()
  end

  #csvからデータベースにデータを登録する
  # def import 
  #   Organism.import(params[:file])
  #   redirect_to database_show_path
  # end
end
