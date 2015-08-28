class AddRankToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :position, :string
  end
end
