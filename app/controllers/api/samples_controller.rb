class Api::SamplesController < ApplicationController
  before_action :set_sample, only: [ :show, :update, :destroy ]

  def index
    @samples = @current_user.samples
    render json: @samples
  end

  def show
    render json: @sample
  end

  def create
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
    params.require(:sample).permit(:name, :audio_url)
  end
end
