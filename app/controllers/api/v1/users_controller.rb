class Api::V1::UsersController < ApiController

  def show
    render json: [eth_nonce: user.eth_nonce] if user.present?
  end

  def mint
    unless user.is_minted?
      to = ENV['CONTRACT_ADDRESS']

      data = '0x'

      tlwh = TLWH.new
      data += tlwh.func_mint.signature

      ipfs_hash = user.generate_ipfs_file
      if ipfs_hash.present?
        data += Eth::Util.bin_to_hex(Eth::Abi.encode([:string], [ipfs_hash]))
      end
      render json: [eth_to: to, eth_data: data] if to.present? && data.present?
    end
  end

  private

  def user
    eth_address = Eth::Address.new(params[:id])
    @user ||= User.find_by(eth_address: params[:id].downcase) if eth_address.valid?
  end
end
