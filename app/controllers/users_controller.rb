class UsersController < ApplicationController
  
  before_action :logged_in_user, only:[:index, :edit, :update, :destroy]
  before_action :correct_user, only:[:edit, :update, :destroy]
  
  def index
    @users=User.paginate(page:params[:page])
  end
  
  def show
    @user=User.find(params[:id])
    # debugger
    # list next step etc
    @microposts=@user.microposts.paginate(page:params[:page])
  end
  
  def new
    @user=User.new
  end
  
  def create
    @user=User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "アカウント登録完了"
      redirect_to @user
                  # user_path(@user.id)
                  # user_path(@user)
                  # "/users/#{@user,id}"
                  # redirect_toはデフォルトで@userだけで自動的にidを読み込んでくれる
    else
      render 'new'
                  # redirect_toはgetリクエストを渡す
                  # render はテンプレートに飛ばす
    end
  end
  
  def edit
    @user=User.find(params[:id])
  end
  
  def update
    @user=User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success]="更新しました"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました"
    redirect_to root_path
  end

  private
  
  def user_params
    params.require(:user).permit(
      :name, :email, :password,
      :password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end
  
end
