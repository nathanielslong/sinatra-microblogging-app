require 'pg'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'

enable :sessions

configure :development do
  set :database, 'sqlite3:quickcuts.sqlite3'
end

get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
  end

  @posts = Post.last(10)

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
  user = User.new

  user.email = params[:email]
  user.password = params[:password]
  user.fname = params[:fname].capitalize
  user.lname = params[:lname].capitalize
  user.birthday = params[:birthday]
  user.city = params[:city].capitalize
  user.country = params[:country].capitalize

  if user.save
    session[:user_id] = user.id

    flash[:notice] = "You've signed up successfully!"

    redirect '/'
  else
    flash[:notice] = user.errors.full_messages.to_sentence

    redirect '/'
  end

end

get '/users/:id' do
  @user = User.find(params[:id])

  erb :user_profile
end

get '/users/:id/delete' do
  Post.where(user_id: session[:user_id]).destroy_all
  User.find(session[:user_id]).destroy

  session.clear

  flash[:notice] = "Sad to see you go!"

  redirect '/'
end

get '/users/:id/edit' do
  @user = User.find(session[:user_id])

  erb :edit_account
end

post '/users/:id/edit' do
  @user = User.find(session[:user_id])

  @user.assign_attributes(email: params[:email],
                          password: params[:password],
                          fname: params[:fname],
                          lname: params[:lname],
                          birthday: params[:birthday],
                          city: params[:city],
                          country: params[:country],
                          picture: params[:picture])

  if @user.save
    session[:user_id] = @user.id

    flash[:notice] = "Account successfully edited!"

    redirect '/'
  else
    flash[:notice] = @user.errors.full_messages.to_sentence

    redirect '/'
  end

end

get '/users/:id/follow' do
  user = User.find(params[:id])
  current_user = User.find(session[:user_id])

  current_user.follow!(user) if user

  flash[:notice] = "You've followed successfully!"

  redirect '/'
end

post '/users/:id/follow' do
  # user = User.find(params[:id])
  # current_user = User.find(session[:user_id])

  # current_user.follow(user) if user

  flash[:notice] = "You've stopped following this user!"

  redirect '/'
end

get '/posts/new' do
  erb :create_post
end

post '/posts' do
  @user = User.find(session[:user_id])

  new_post = @user.posts.new(body: params[:body],
                             genre: params[:genre],
                             album: params[:album],
                             artist: params[:artist])

  if new_post.save
    flash[:notice] = "Post successfully created!"

    redirect '/'
  else
    flash[:notice] = new_post.errors.full_messages.to_sentence

    redirect '/'
  end

end

get '/posts/:id' do
  @post = Post.find(params[:id])
  @user = User.find(@post.user_id)

  erb :post_show
end

get '/posts/:id/edit' do
  @post = Post.find(params[:id])

  erb :post_edit
end

post '/posts/:id/edit' do
  @post = Post.find(params[:id])

  @post.assign_attributes(body: params[:body],
                          genre: params[:genre],
                          album: params[:album],
                          artist: params[:artist])

  if @post.save

    flash[:notice] = "Post successfully edited!"

    redirect '/'

  else
    flash[:notice] = @post.errors.full_messages.to_sentence

    redirect '/'
  end

end

get '/posts/:id/delete' do
  Post.find(params[:id]).destroy

  flash[:notice] = "Bye bye post!"

  redirect '/'
end
