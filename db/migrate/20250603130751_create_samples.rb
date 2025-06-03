class CreateSamples < ActiveRecord::Migration[7.2]
  def change
    create_table :samples do |t|
      t.string :name
      t.string :audio_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
