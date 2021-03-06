class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :following_id

      t.timestamps
      t.index [:follower_id, :following_id], unique: true
    end
  end
end
