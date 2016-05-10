class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
 
   def show # 追加
   @user = User.find(params[:id])
   @microposts = @user.microposts.order(created_at: :desc).page(params[:page]).per(5)
   
   #      User.page(7).per(50).padding(3)

   end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
    flash[:success] = "Welcome to the Sample App!"
    redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    if @user.update(user_params)
     redirect_to root_path , notice: '編集しました'
    else
      render 'edit'
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @fusers = @user.following_users
  end
  
  def followers
    @user = User.find(params[:id])
    @fusers = @user.follower_users
  end
  
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:area,:profile)
  end
  
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url)unless @user == current_user
  end
end