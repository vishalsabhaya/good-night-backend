class CreateFollowings < ActiveRecord::Migration[7.0]
  def change

    create_table :followings do |t|
      t.references :user, foreign_key: { to_table: :users }, comment: 'user id'
      t.references :following_user, foreign_key: { to_table: :users }, comment: 'following of user id'
      t.timestamps
    end

    add_index :followings, %i[user_id following_user_id], unique: true, name: 'user_follower_index'

  end
end
