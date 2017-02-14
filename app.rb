require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'pg'
require './models'
require './environments'

enable :sessions

get '/' do
  erb :index
end

get '/sign-in' do
  erb :sign_in
end

post "/sign-in" do
  @user = User.where(email: params[:email]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "You've signed in successfully! Your name is #{@user.fname} #{@user.lname}"
  else
    flash[:notice] = "There was a problem with sign-in."
  end
  redirect "/"
end

get "/sign-out" do
  session.clear
  flash[:notice] = "You've signed out!"
  redirect "/"
end
