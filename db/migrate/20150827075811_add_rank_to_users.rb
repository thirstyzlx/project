class AddRankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rankb, :integer
    add_column :users, :ranks, :integer
    add_column :users, :rankBadge,:string
  end
end
