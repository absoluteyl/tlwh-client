class UsersController < ApplicationController
  before_action :require_login, only: [:index, :show]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user and @user.username?
      if @user.eth_address && Eth::Address.new(@user.eth_address).valid?
        @user.eth_nonce = get_new_nonce
        if @user.save
          redirect_to login_path, notice: "Successfully created an account, you may now log in."
        else
          redirect_to login_path, alert: "Account already exists! Try to log in instead!"
        end
      else
        flash.now[:alert] = "Failed to get Ethereum address or Invalid Ethereum address!"
        render :new
      end
    else
      flash.now[:alert] = "Please enter a username!"
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:username, :eth_address)
  end
end
