class RemoveAudioUrlFromSamples < ActiveRecord::Migration[7.2]
  def change
    remove_column :samples, :audio_url, :string
  end
end
