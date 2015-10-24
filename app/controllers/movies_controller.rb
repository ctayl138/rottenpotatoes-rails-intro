class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = ['G','PG','PG-13','R']
    
    if params[:ratings]
      session[:ratings] = params[:ratings]  
    elsif !params[:ratings] && !session[:ratings]
      session[:ratings] = {'G' => 1,'PG'=> 1,'PG-13'=> 1,'R'=> 1}
    end
    
    if params[:checked_ratings]
      temp = {}
      params[:checked_ratings].each  {|x| temp[x] = 1}
      session[:ratings] = temp
    end
    
    @checked_ratings = Array.new
    session[:ratings].each_key {|key| @checked_ratings.push(key)}
    
    if session[:sort] == "title" && params[:sort] == nil || params[:sort] == "title"
      sort = "title"
      @title_header = "hilite"
    elsif (session[:sort] == "release_date" && params[:sort] == nil) || params[:sort] == "release_date"
      sort = "release_date"
      @release_date_header = "hilite"
    else
      sort = 1
    end
    
    @movies = Movie.order(sort).where(rating: @checked_ratings)
    
    if (session[:sort] != params[:sort] && params[:sort] != nil) || (session[:ratings] != params[:ratings] && params[:ratings] != nil)
        session[:sort] = params[:sort] 
        session[:ratings] = params[:ratings]
        flash.keep
        redirect_to movies_path(:sort => session[:sort], :ratings => @checked_ratings) and return
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
