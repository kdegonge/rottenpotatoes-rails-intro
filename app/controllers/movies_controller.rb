class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    #defs
    @movies = Movie.all
    @param_sort = params[:param_sort]
    @param_rating = params[:ratings]
    @all_ratings = Movie.all_ratings

    redirect = false
    
    #session
    if :param_sort
      session[:param_sort] = params[:param_sort]
    elsif session[:param_sort]
      @param_sort = session[:param_sort]
      redirect = true
    else
      @param_sort = nil
    end
    
    #keep settings if refresh
    if params[:commit] == "Refresh" and @param_rating.nil?
      @ratings = nil
      session[:ratings] = nil
    elsif @param_rating
      @ratings = @param_rating
      session[:ratings] = @param_rating
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = nil
    end
    
    if redirect
      flash.keep
      redirect_to movies_path :param_sort=>@param_sort, :ratings=>@ratings
    end
    
    #control logic for sorts/filters
    if @ratings and @param_sort
      @movies = Movie.where(:rating => @ratings.keys).order(@param_sort)
    elsif @param_sort
      @movies = Movie.order(@param_sort)
    elsif @ratings
      @movies = Movie.where(:rating => @ratings.keys)
    else
      @movie = Movie.all
    end
  
    if !@ratings
      @ratings = Hash.new
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


end