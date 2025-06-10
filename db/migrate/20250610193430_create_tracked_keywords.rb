class CreateTrackedKeywords < ActiveRecord::Migration[8.0]
  def change
    create_table :tracked_keywords do |t|
      t.string :keyword
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
