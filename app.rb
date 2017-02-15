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
  redirect '/'
end

get '/posts/:id' do
  @post = Post.find(params[:id])
  erb :post_show
end
