require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT,
			"phone" TEXT,
			"dateStamp" TEXT,
			"barber" TEXT,
			"colore" TEXT
		)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit 
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { :username => 'Введите ваше имя',
		   :phone => 'Введите номер телефона', 
		   :datetime => 'Введите дату и время'}

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into
		Users
		(
			name,
			phone,
			datestamp,
			barber,
			colore
			)
			values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	erb "Ok! Ваше имя: #{@username}, ваш номер телефона: #{@phone}, время записи: #{@datetime}, ваш мастер: #{@barber} , Цвет волос: #{@color}"
end

def get_db
	return SQLite3::Database.new 'barbershop.db'
end
