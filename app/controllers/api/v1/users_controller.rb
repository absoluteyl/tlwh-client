class Api::V1::UsersController < ApiController

  def show
    eth_address = Eth::Address.new(params[:id])
    user = User.find_by(eth_address: params[:id].downcase) if eth_address.valid?

    render json: [eth_nonce: user.eth_nonce] if user.present?
  end
end
