class OrganismsController < ApplicationController

  def top
    File.open("label.json") do |f|
      @class_data = JSON.load(f).keys()
    end

    if params[:search].present? # TODO: 条件の絞り込みで検索をおこなう
      @organisms = Organism.where(classes: params[:search]).page(params[:page])
    else
      @organisms = Organism.all.page(params[:page])
    end
  end

  def create
    @organisms = Organism.all.page(params[:page])
    if Organism.where(replicon: params[:acc]).present? #データベースに存在するかチェック
      @page_title = params[:acc]
      flash[:acc] = params[:acc]
    else 
      redirect_to root_path, alert: "データベースに登録されていない生物です"
    end
  end

  def download
    send_file "app/assets/images/#{flash[:acc]}.png" 
  end

  def predict
    @organisms = Organism.all.page(params[:page])
    entry = Genome.new()
    @page_title = params[:acc]
    pre_class = entry.deepL(params[:acc])

    if pre_class == false
      redirect_to root_path, alert: "データベースに登録されていない生物です"
    else
      @res_class = pre_class
    end
  end

  # csvからデータベースにデータを登録する
  def import 
    Organism.import(params[:file])
    redirect_to root_path
  end
end
