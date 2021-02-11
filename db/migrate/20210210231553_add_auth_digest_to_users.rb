class AddAuthDigestToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :auth_digest, :string
  end
end
