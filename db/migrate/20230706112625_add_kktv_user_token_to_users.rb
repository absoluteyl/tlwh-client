class AddKktvUserTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :kktv_user_token, :string
  end
end
