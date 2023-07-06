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
end
