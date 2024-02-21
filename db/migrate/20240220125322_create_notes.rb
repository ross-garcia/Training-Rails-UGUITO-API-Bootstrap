class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.belongs_to :user, foreign_key: true
      t.string :title, null: false
      t.string :content, null: false
      t.integer :note_type, default: 0, null: false

      t.timestamps
    end
  end
end
