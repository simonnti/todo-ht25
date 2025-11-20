require 'sinatra'
require 'sqlite3'
require 'slim'
require 'sinatra/reloader'

post('/index/:id/delete') do
  id = params[:id].to_i
  db = SQLite3::Database.new("db/tasks.db")
  db.execute("DELETE FROM tasks WHERE id = ?", id)
  redirect('/index')
end

post('/task') do
  db = SQLite3::Database.new("db/tasks.db")
  db.results_as_hash = true
  new_task = params[:new_task]
  description = params[:description]
  db.execute("INSERT INTO tasks (name, description) VALUES (?,?)",[new_fruit,description])
  redirect('/index')
end

get('/index/:id/edit') do
  db = SQLite3::Database.new("db/tasks.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @spestask = db.execute("SELECT * FROM tasks WHERE id = ?", [id]).first
  slim(:"edit")
end

post('/index/:id/update') do
  id = params[:id].to_i
  name = params[:name]
  description = params[:description]
  db = SQLite3::Database.new("db/tasks.db")
  db.execute("UPDATE tasks SET name=?, description=? WHERE id=?",[name,description,id])
  redirect('/index')
end