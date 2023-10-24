class OrganismsController < ApplicationController

  def top
    load_class_data

    if params[:search].present? # TODO: 条件の絞り込みで検索をおこなう
      @organisms = Organism.where(classes: params[:search]).page(params[:page])
    else
      @organisms = Organism.all.page(params[:page])
    end
  end

  def create
    @organisms = Organism.all.page(params[:page])
    if Organism.where(replicon: params[:acc]).present? #データベースに存在するかチェック
      @selected_acc = params[:acc]
      begin
        img_path = "app/assets/images/#{@selected_acc}.png"
        raise StandardError, "imgファイルが存在しません" unless File.exist?(img_path)
      rescue StandardError => e
        handle_error(e.message)
      end
    else 
      handle_error("データベースに登録されていない生物です")
    end
  end

  def download
    img_path = "app/assets/images/#{params[:acc]}.png"
    if File.exist?(img_path)
      send_file img_path
    else
      handle_error("ファイルが見つかりません")
    end
  end

  def predict
    @organisms = Organism.all.page(params[:page])
    entry = Genome.new()
    @selected_acc= params[:acc]

    begin
      pre_class = entry.deepL(params[:acc])
      if pre_class == false
        raise StandardError, "データベースに登録されていない生物です"
      else
        @res_class = pre_class
      end
    rescue Net::HTTPError, StandardError => e
      handle_error(e)
    end
  end

  # csvからデータベースにデータを登録する
  def import 
    Organism.import(params[:file])
    redirect_to root_path
  end
end

private

def load_class_data
  File.open("label.json") do |f|
    @class_data = JSON.load(f).keys
  end
end

def handle_error(message)
  flash[:danger] = message
  redirect_to root_path
end