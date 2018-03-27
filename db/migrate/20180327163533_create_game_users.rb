class CreateGameUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :game_users do |t|
      t.references :user, foreign_key: true
      t.references :game, foreign_key: true
      t.integer :player

      t.timestamps
    end
  end
end
