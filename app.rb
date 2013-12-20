require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:///blog.db"

class Post < ActiveRecord::Base
end

helpers do
	#If @title is assigned, add it to the page's title.
	def title
		if @title
			"#{@title} -- My Blog"
		else
			"My Blog"
		end

		#Format the Ruby Time object returned from a post's created_at method
		#into a string that looks like this: 20 December 2013
		def pretty_date(time)
			time.strftime("%d %b %Y")
		end
	end

#get all routes
get "/" do
  @posts = Post.order("created_at DESC")
  erb :"posts/index"
end

#get the new post form
get '/posts/new' do
	@title = "New Post"
	@post = Post.new
	erb :"posts/new"
end

# The New Post form sends a POST request (storing data) here
# where we try to create the post it sent in its params hash.
# If successful, redirect to that post. Otherwise, render the "posts/new"
# template where the @post object will have the incomplete data that the 
# user can modify and resubmit.

post '/posts' do
	@post = Post.new(params[:post])
	if @post.save
		redirect "posts/#{@post.id}"
	else
		erb "posts/new"
	end
end

#get the individual page of the post with this ID.

get "/posts/:id" do
	@post = Post.find(params[:id])
	@title = @post.title
	erb :"posts/show"
end

#get the edit post form of the post with this ID
get "/posts/:id/edit" do
	@post = Post.find(params[:id])
	@title = "Edit Form"
	erb :"posts/edit"
end

# The Edit Post form sends a PUT request (modifying data) here.
# If the post is updated successfully, redirect to it. Otherwise,
# render the edit form again with the failed @post object still in memory
# so they can retry.
put "/posts/:id" do
	@post = Post.find(params[:id])
	if @post.update_attributes(params[:post])
		redirect "/posts/#{@post.id}"
	else
		erb :"posts/edit"
	end
end

#delete the post with this ID and redirects to the homepage
delete '/posts/:id' do
	@post = Post.find(params[:id]).destroy
	redirect '/'
end

#About me page
get '/about' do
	@title = "About Me"
	erb :"pages/about"
end

end
