class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :name
      t.datetime :release_date
      t.string :developer
      t.timestamps
    end
  end
end
