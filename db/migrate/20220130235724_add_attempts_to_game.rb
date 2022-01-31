class AddAttemptsToGame < ActiveRecord::Migration[7.0]
  def change
    create_table :attempts do |t|
      t.string :letters, array: true, null: false, default: []
      t.belongs_to :game, foreign_key: true

      t.timestamps
    end
  end
end
