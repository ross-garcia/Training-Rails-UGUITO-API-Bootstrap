class AddContentLengthToUtilities < ActiveRecord::Migration[6.1]
  def change
    add_column :utilities, :content_length_short, :integer
    add_column :utilities, :content_length_medium, :integer
  end
end
