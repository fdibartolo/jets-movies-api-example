class MoviesController < ApplicationController
  class_iam_policy("dynamodb")
  before_action :set_movie, only: [:show, :update, :delete]

  # GET /movies
  def index
    render json: Movie.all
  end

  # GET /movies/1
  def show
    render json: @movie
  end

  # POST /movies
  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      render json: @movie, status: :created
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # PUT /movies/1
  def update
    if @movie.update(movie_params)
      render json: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  # DELETE /movies/1
  def delete
    status = @movie.destroy
    render json: {deleted: status}
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :year, :info => {})
  end
end
