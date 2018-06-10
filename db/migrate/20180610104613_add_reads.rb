class AddReads < ActiveRecord::Migration[5.1]
  def change
    create_table :reads do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.string :excerpt
      t.integer :stars
      t.timestamps null: false
    end
  end
end
