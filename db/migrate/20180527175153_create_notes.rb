class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.string :year, null: false
      t.date :created_at, null: false
      t.date :updated_at, null: false
    end
  end
end
