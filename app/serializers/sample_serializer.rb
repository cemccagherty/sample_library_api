class SampleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :audio_url

  def audio_url
    if object.audio.attached?
      url_for(object.audio)
    else
      nil
    end
  end
end
