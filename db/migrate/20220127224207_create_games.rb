class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :word, null: false
      t.integer :attempt_limit, null: false, default: 6

      t.timestamps
    end
  end
end
