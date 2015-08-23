class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :gametime
      t.string :player1ID
      t.string :player2ID

      t.timestamps null: false
    end
  end
end
