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
    upload_file = sample_params[:audio]

    unless upload_file && ALLOWED_FILE_TYPES.include?(upload_file.content_type)
      return render json: { error: "MP3 or WAV only" }, status: :unprocessable_entity
    end

    if upload_file.size > MAX_FILE_SIZE
      return render json: { error: "Upload size maximum: 10MB" }, status: :unprocessable_entity
    end

    # audio upload file validations done here to validate prior to upload to cloudinary.

    @sample = Sample.new(sample_params)
    @sample.user = @current_user

    if @sample.save
      render json: @sample, status: :created # returns HTTP 201
    else
      render json: { errors: @sample.errors.full_messages }, status: :unprocessable_entity # returns HTTP 422
    end
  end

  def update
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
end
