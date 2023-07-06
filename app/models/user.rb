class User < ApplicationRecord

  validates :eth_address, presence: true, uniqueness: true
  validates :eth_nonce, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  def is_minted?
    tlwh = TLWH.new
    tlwh.eth_client.call(
      tlwh.contract,
      'balanceOf',
      self.eth_address
    ) == 1
  end

  def generate_ipfs_file
    tlwh = TLWH.new
    token_id = tlwh.eth_client.call(tlwh.contract, 'totalSupply') + 1
    ipfs_data = {
      id: token_id,
      name: "The Last Watch Hist ##{token_id}",
      owner: self.eth_address,
      image: Ipfs.url(ENV['NFT_IMAGE_ID']),
    }
    tmp = Tempfile.new("TLWH-#{token_id}")
    tmp.write(ipfs_data.to_json)
    tmp.close

    ipfs_client = Ipfs.client
    ipfs_client.add(tmp.path)['Hash']
  end
end
