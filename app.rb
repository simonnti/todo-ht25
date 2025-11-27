require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'

# Routen /
get('/') do
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true

    @datadih = db.execute("SELECT * FROM todos")

    querya = params[:q]

    if querya && !querya.empty?
        @datadih = db.execute("SELECT * FROM todos WHERE name LIKE ?","%#{querya}%")
    else
        @datadih = db.execute("SELECT * FROM todos")
    end

    slim(:index)
end