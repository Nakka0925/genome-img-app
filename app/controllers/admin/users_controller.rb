class Admin::UsersController < ApplicationController

  before_action :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "ユーザー「#{@user.name}を登録しました。"
      redirect_to admin_user_url(@user)
    else 
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "ユーザー「#{@user.name}を更新しました。"
      redirect_to admin_user_url(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を削除しました。"
  end

  private

  def require_admin
    redirect_to root_path unless current_user.admin?
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end
end