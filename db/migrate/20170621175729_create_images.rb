class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.belongs_to :message, index: true
      t.text :body
      t.timestamps
    end
  end
end
