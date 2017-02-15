require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'pg'
require './models'
require './environments'

enable :sessions

get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
  end
  erb :index
end

get '/sign-in' do
  erb :sign_in
end

post '/sign-in' do
  @user = User.where(email: params[:email]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "You've signed in successfully! Your name is #{@user.fname} #{@user.lname}"
  else
    flash[:notice] = "There was a problem with sign-in."
  end
  redirect '/'
end

get '/sign-out' do
  session.clear
  flash[:notice] = "You've signed out!"
  redirect '/'
end

get '/sign-up' do
  erb :sign_up
end

post '/sign-up' do
  @user = User.new
  @user.email = params[:email]
  @user.password = params[:password]
  @user.fname = params[:fname]
  @user.lname = params[:lname]
  @user.birthday = params[:birthday]
  @user.city = params[:city]
  @user.country = params[:country]
  @user.save
  session[:user_id] = @user.id
  flash[:notice] = "You've signed up successfully!"
  redirect '/'
end

get '/account/delete' do
  User.find(session[:user_id]).destroy
  session.clear
  flash[:notice] = "Sad to see you go!"
  redirect '/'
end

get '/account/edit' do
  @user = User.find(session[:user_id])
  erb :edit_account
end

post '/account/edit' do
  @user = User.find(session[:user_id])
  @user.email = params[:email]
  @user.password = params[:password]
  @user.fname = params[:fname]
  @user.lname = params[:lname]
  @user.birthday = params[:birthday]
  @user.city = params[:city]
  @user.country = params[:country]
  @user.save
  flash[:notice] = "Account successfully edited!"
  redirect '/'
end

get '/posts/new' do
  erb :create_post
end

post '/posts' do
  @user = User.find(session[:user_id])
  @user.posts.create(title: params[:title], body: params[:body], genre: params[:genre], album: params[:album], artist: params[:artist])
  flash[:notice] = "Post successfully created!"
  redirect '/'
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  erb :post_show
end

get '/posts/:id/edit' do
  @post = Post.find(params[:id])
  erb :post_edit
end

post '/posts/:id/edit' do
  @post = Post.find(params[:id])
  @post.title = params[:title]
  @post.body = params[:body]
  @post.genre = params[:genre]
  @post.album = params[:album]
  @post.artist = params[:artist]
  @post.save
  flash[:notice] = "Post successfully edited!"
  redirect '/'
end

