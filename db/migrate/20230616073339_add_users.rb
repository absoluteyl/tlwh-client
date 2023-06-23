class AddUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :eth_address, index: true
      t.string  :eth_nonce
      t.string  :username, index: true
      t.timestamps
    end
  end
end
