class BookmarksController < ApplicationController
  
  before_action(:load_current_user)

  def load_current_user
    @current_user = User.where({ :id => session[:user_id] }).at(0)
  end
  
  def index
    # matching_bookmarks = Bookmark.where({ :user_id => session.fetch(:user_id)})

    # The "session[:user_id]" is just the abbreviated verstion of "session.fetch(:user_id)".

    # @current_user = User.where({ :id => session[:user_id] }).at(0)
  
    # self.load_current_user

    matching_bookmarks = @current_user.bookmarks

    @list_of_bookmarks = matching_bookmarks.order({ :created_at => :desc })

    render({ :template => "bookmarks/index.html.erb" })
  end

  def show
    # self.load_current_user

    the_id = params.fetch("path_id")

    matching_bookmarks = Bookmark.where({ :id => the_id })

    @the_bookmark = matching_bookmarks.at(0)

    render({ :template => "bookmarks/show.html.erb" })
  end

  def create
    # self.load_current_user

    the_bookmark = Bookmark.new
    the_bookmark.user_id = session.fetch(:user_id)
    the_bookmark.movie_id = params.fetch("query_movie_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks", { :notice => "Bookmark created successfully." })
    else
      redirect_to("/bookmarks", { :notice => "Bookmark failed to create successfully." })
    end
  end

  def update
    # self.load_current_user

    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.user_id = params.fetch("query_user_id")
    the_bookmark.movie_id = params.fetch("query_movie_id")

    if the_bookmark.valid?
      the_bookmark.save
      redirect_to("/bookmarks/#{the_bookmark.id}", { :notice => "Bookmark updated successfully."} )
    else
      redirect_to("/bookmarks/#{the_bookmark.id}", { :alert => "Bookmark failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_bookmark = Bookmark.where({ :id => the_id }).at(0)

    the_bookmark.destroy

    redirect_to("/bookmarks", { :notice => "Bookmark deleted successfully."} )
  end
end
