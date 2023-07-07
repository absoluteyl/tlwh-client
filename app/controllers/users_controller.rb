class UsersController < ApplicationController
  before_action :require_login, except: :index
  before_action :require_authorize, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    # Retrieve KKTV watch history
    @watch_hist = generate_watch_hist if @user.kktv_user_token.present?
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

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :eth_address, :kktv_user_token)
  end

  def generate_watch_hist
    raw_watch_hist = Kktv.client.watch_hist(@user)
    watch_hist = []
    raw_watch_hist.each do |hist|
      detail = Kktv.client.title_detail(@user, hist[:title][:id])
      item = {}
      # General Info
      item[:name]  = hist[:title][:name]
      item[:cover] = detail[:cover]
      item[:link]  = detail[:deeplink]

      # Watch History
      item[:progress] = hist[:display][:description]

      # Meta
      item[:type] = case hist[:title][:title_type]
        when "film"
          "Movie"
        when "miniseries", "series"
          "TV Series"
        end
      item[:year] = detail[:release_year]
      item[:categories] = detail[:genres].to_a + detail[:themes].to_a
      item[:categories] = item[:categories].map{ |c|
        next if c[:collection_name].in?(['免費', '語言學習', '雙字幕'])
        c[:collection_name]
      }.compact.join(', ')

      item[:casts] = detail[:casts].map{ |c| c[:collection_name] }.join(", ") if detail[:casts].present?

      item[:crews] = detail[:directors].to_a + detail[:producers].to_a
      item[:crews] = item[:crews].to_a.map{ |c| c[:collection_name] }.compact.join(', ')
      watch_hist << item
    end
    watch_hist
  end
end
