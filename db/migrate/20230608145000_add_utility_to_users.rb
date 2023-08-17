class AddUtilityToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :utility
    add_foreign_key :users, :utilities
  end
end
