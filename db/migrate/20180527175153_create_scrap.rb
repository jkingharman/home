class CreateScrap < ActiveRecord::Migration[5.1]
  def change
    create_table :scraps do |t|
      t.string :title
      t.text :body
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
