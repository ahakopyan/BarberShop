require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'SQLite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers 

	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end

end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

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

	db.execute 'CREATE TABLE IF NOT EXISTS
		"Barbers" 
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"name" TEXT
		)'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc';

	erb :showusers
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
			values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	erb "Ok! Ваше имя: #{@username}, ваш номер телефона: #{@phone}, время записи: #{@datetime}, ваш мастер: #{@barber} , Цвет волос: #{@color}"
end

post '/showusers' do

end


