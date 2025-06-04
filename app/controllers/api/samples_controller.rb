class Api::SamplesController < ApplicationController
  before_action :set_sample, only: [ :show, :update, :destroy ]

  MAX_FILE_SIZE = 10.megabytes
  ALLOWED_FILE_TYPES = [ "audio/mpeg", "audio/wav", "audio/x-wav", "audio/mp3" ]

  def index
    @samples = @current_user.samples
    render json: @samples
  end

  def show
    render json: @sample
  end

  def create
    audio_file = sample_params[:audio]

    if (error = validate_audio_file(audio_file))
      return render json: { error: error }, status: :unprocessable_entity
    end

    @sample = Sample.new(sample_params)
    @sample.user = @current_user

    if @sample.save
      render json: @sample, status: :created # returns HTTP 201
    else
      render json: { errors: @sample.errors.full_messages }, status: :unprocessable_entity # returns HTTP 422
    end
  end

  def update
    audio_file = sample_params[:audio]

    # skip validation if no new audio file provided
    if audio_file && (error = validate_audio_file(audio_file))
      return render json: { error: error }, status: :unprocessable_entity
    end

    if @sample.update(sample_params)
      render json: @sample
    else
      render json: { errors: @sample.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @sample.destroy
    head :no_content # returns HTTP 204 "no content"
  end

  private

  def set_sample
    @sample = @current_user.samples.find_by(id: params[:id])
    render json: { error: "Not Found" }, status: :not_found unless @sample # returns HTTP 404 "not found"
  end

  def sample_params
    params.require(:sample).permit(:name, :audio)
  end

  def validate_audio_file(audio_file)
    # validates prior to cloudinary upload.

    return "No audio file provided" unless audio_file

    return "MP3 or WAV only" unless ALLOWED_FILE_TYPES.include?(audio_file.content_type)

    return "10MB maximum file size" if audio_file.size > MAX_FILE_SIZE

    nil
  end
end
