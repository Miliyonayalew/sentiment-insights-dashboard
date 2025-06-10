class CreateMentions < ActiveRecord::Migration[8.0]
  def change
    create_table :mentions do |t|
      t.string :title
      t.text :content
      t.string :sentiment
      t.string :source
      t.datetime :published_at
      t.string :url
      t.references :tracked_keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
