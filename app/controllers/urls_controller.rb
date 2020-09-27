class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :stats]

  def show
    if @url && @url.increment_counter!
      render json: { original_url: @url.original_url }
    else
      render json: { errors: ['url not found'] }, status: 404
    end
  end

  def create
    url = Url.new(url_params)
    if url.save
      render json: { short_url: url.short_url }
    else
      render json: { errors: url.errors.full_messages }, status: 422
    end
  end

  def stats
    if @url
      render json: { url: @url.short_url, count: @url.counter }
    else
      render json: { errors: ['url not found'] }, status: 404
    end
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def set_url
    @url = Url.find_by(short_url: params[:short_url])
  end
end
