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

post('/:id/delete') do
    id = params[:id].to_i
    db = SQLite3::Database.new("db/todos.db")
    db.execute("DELETE FROM todos WHERE id = ?", id)
    redirect('/')
end

get('/:id/edit') do
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    id = params[:id].to_i
    @datadih = db.execute("SELECT * FROM todos WHERE id = ?", [id]).first
    slim(:"/edit")
end

post("/:id/update") do
    id = params[:id].to_i
    name = params[:name]
    description = params[:amount].to_i
    db = SQLite3::Database.new("db/todos.db")
    db.execute("UPDATE todos SET name=?, description=? WHERE id=?", [name,description,id])
    redirect('/')
end

post('/') do
    db = SQLite3::Database.new("db/todos.db")
    db.results_as_hash = true
    new_task = params[:new_task]
    description = params[:description]
    state = params[:state]
    db.execute("INSERT INTO todos (name, description, state) VALUES (?,?, 0)", [new_task, description])
    redirect('/')
end