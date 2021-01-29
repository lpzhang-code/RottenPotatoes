class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # check for filtering
    if params[:ratings]
      session[:ratings] = params[:ratings].keys
    end

    # check for sorting
    if params[:sort]
      session[:sort] = params[:sort]
    end

    # prepare instance variables
    @all_ratings = Movie.all_ratings
    
    if session[:ratings] 
      @ratings_to_show = session[:ratings]
    else
      @ratings_to_show = []
    end
    
    # handle cases: (1) sort by title, (2) sort by release date, (3) no sorting
    case session[:sort]
    when 'title'
      @title_header = 'hilite bg-warning'
      if session[:ratings]
        @movies = Movie.where(rating: @ratings_to_show).order('title')
      else
        @movies = Movie.order('title')
      end
    when 'release_date'
      @date_header = 'hilite bg-warning'
      if session[:ratings]
        @movies = Movie.where(rating: @ratings_to_show).order('release_date DESC')
      else
        @movies = Movie.order('release_date DESC')
      end
    else
      if session[:ratings]
        @movies = Movie.where(ratings: @ratings_to_show)
      else
        @movies = Movie.all
      end
    end
  end



  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
