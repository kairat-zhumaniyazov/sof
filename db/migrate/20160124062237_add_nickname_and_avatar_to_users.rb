class AddNicknameAndAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string, { index: true, unique: true }
    add_column :users, :avatar, :string
  end
end
