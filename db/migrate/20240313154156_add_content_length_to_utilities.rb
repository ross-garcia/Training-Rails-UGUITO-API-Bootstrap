class AddContentLengthToUtilities < ActiveRecord::Migration[6.1]
  def change
    add_column :utilities, :content_length_short, :integer, default: 50
    add_column :utilities, :content_length_medium, :integer, default: 100
  end
end
