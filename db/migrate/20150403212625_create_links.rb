class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.string :permalink
      
      t.integer :user_id, :score, :num_comments, :created


      t.timestamps null: false
    end
  end
end
